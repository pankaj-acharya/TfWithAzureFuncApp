terraform {
  required_version = "=1.0.7"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.92.0"
    }
  }
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

# Create resource group first

resource "azurerm_virtual_network" "vnet" {
  name                = local.vnet_name
  location            = local.location
  resource_group_name = local.resource_group_name
  address_space       = local.vnet.address_space
  tags                = local.tags
}

resource "azurerm_subnet" "functionapp" {
  depends_on           = [azurerm_virtual_network.vnet]
  name                 = local.vnet.functionapp_subnet_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = local.resource_group_name
  address_prefixes     = local.vnet.functionapp_address_prefixes
  service_endpoints    = local.vnet.service_endpoints
}

resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                = local.log_analytics.name
  location            = local.location
  resource_group_name = local.resource_group_name
  sku                 = local.log_analytics.sku
  tags                = local.tags
}

module "application_insights" {
  source                                = "../../modules/tf-mce-azurerm-application-insights"
  name                                  = local.applicationinsights.name
  location                              = local.location
  resource_group_name                   = local.resource_group_name
  application_type                      = local.applicationinsights.application_type
  retention_in_days                     = local.applicationinsights.retention_in_days
  daily_data_cap_in_gb                  = local.applicationinsights.daily_data_cap_in_gb
  daily_data_cap_notifications_disabled = local.applicationinsights.daily_data_cap_notifications_disabled
  sampling_percentage                   = local.applicationinsights.sampling_percentage
  disable_ip_masking                    = local.applicationinsights.disable_ip_masking
  workspace_id                          = local.applicationinsights.workspace_id
  local_authentication_disabled         = local.applicationinsights.local_authentication_disabled
  internet_ingestion_enabled            = local.applicationinsights.internet_ingestion_enabled
  internet_query_enabled                = local.applicationinsights.internet_query_enabled
  tags                                  = local.tags
}

module "storage" {
  for_each             				= local.storage_accounts
  source               				= "../../modules/tf-mce-azurerm-storage-account"
  storage_account_name 				= each.value.storage_account_name
  resource_group_name  				= local.resource_group_name
  location             				= local.location
  tags                 				= local.tags
  account_tier         				= each.value.account_tier
  account_kind         				= each.value.account_kind
  infrastructure_encryption_enabled = each.value.infrastructure_encryption_enabled
}

module "app_service_plan" {
  source                       = "../../modules/tf-mce-azurerm-app-service-plan"
  app_service_plan_name        = local.app_service_plan.name
  resource_group_name          = local.resource_group_name
  kind                         = local.app_service_plan.kind
  maximum_elastic_worker_count = local.app_service_plan.maximum_elastic_worker_count
  location                     = local.app_service_plan.location
  sku                          = local.app_service_plan.sku
  reserved                     = local.app_service_plan.reserved
  zone_redundant               = local.app_service_plan.zone_redundant
  tags                         = local.app_service_plan.tags
}

module "function_app" {
  source = "../../modules/tf-mce-azurerm-function-app"
  function_app_name   = local.function_app.name
  resource_group_name = local.resource_group_name
  location            = local.location
  app_service_plan_id = module.app_service_plan.app_service_plan_id
  https_only          = local.function_app.https_only
  app_settings        = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"   = module.application_insights.instrumentation_key
		"EmailSmtpServer": ""
		"EmailSmtpPort": ""
		"EmailUsername": ""
		"EmailPassword": ""
		"EmailFromAddress": ""
  }
  connection_strings              = []
  os_type                         = local.function_app.os_type
  identity                        = local.function_app.identity
  site_configs                    = local.function_app.site_configs
  storage_account_name            = module.storage["001"].storage_account_name
  storage_account_access_key      = module.storage["001"].storage_primary_access_key
  function_app_version            = local.function_app.function_app_version
  tags                            = local.tags

  depends_on = [
    module.app_service_plan, 
    azurerm_subnet.functionapp,
    module.storage
  ]
}

module "key_vault" {
  source   = "../../modules/tf-mce-azurerm-key-vault"
  name                        = local.key_vault.name
  location                    = local.location
  resource_group_name         = local.resource_group_name
  sku_name                    = local.key_vault.sku_name
  tenant_id                   = local.key_vault.tenant_id
  enabled_for_disk_encryption = local.key_vault.enabled_for_disk_encryption
  purge_protection_enabled    = local.key_vault.purge_protection_enabled
  soft_delete_retention_days  = local.key_vault.soft_delete_retention_days
  access_policy               = []
  tags                        = local.tags
}