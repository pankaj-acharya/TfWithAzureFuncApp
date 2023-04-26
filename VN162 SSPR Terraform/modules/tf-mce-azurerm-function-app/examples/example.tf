terraform {
  required_version = "=1.0.7"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.77.0"
    }
  }
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias           = "mcesub"
  subscription_id = var.subscription_id
  features {}
}

variable "location" {
  type    = string
  default = "uksouth"
}

variable "postfix" {
  type    = string
  default = "mce"
}

variable "resource_group_name" {
  type    = string
  default = "mce-function-app-rg"
}

variable "function_app_name" {
  type    = string
  default = "mce-function-app"
}

variable "storage_account_name" {
  type    = string
  default = "mcestorageacc"
}

variable "account_tier" {
  type    = string
  default = "Standard"
}

variable "account_kind" {
  type    = string
  default = "StorageV2"
}

variable "app_service_plan_name" {
  type    = string
  default = "mce-function-app-plan"
}

locals {
  function_app_name          = format("%s-%s", var.resource_group_name, var.postfix)
  resource_group_name        = format("%s-%s", var.resource_group_name, var.postfix)
  app_service_plan_name      = format("%s-%s", var.app_service_plan_name, var.postfix)
  storage_account_name       = lower(format("%s%s", var.storage_account_name, var.postfix))
  location                   = var.location
  app_service_plan_id        = azurerm_app_service_plan.app_service_plan.id
  client_affinity_enabled    = null
  client_cert_mode           = "Optional"
  daily_memory_time_quota    = null
  enabled                    = true
  enable_builtin_logging     = true
  https_only                 = false
  os_type                    = null
  storage_account_access_key = null
  function_app_version       = null

  app_settings = {
    "function_app_title" = "my_first_app"
  }

  auth_settings = {
    enabled                        = false
    additional_login_params        = null
    allowed_external_redirect_urls = []
    default_provider               = null
    issuer                         = null
    runtime_version                = null
    token_refresh_extension_hours  = null
    token_store_enabled            = false
    unauthenticated_client_action  = null
  }

  auth_settings_active_directory = null /* {
      client_id = null
      client_secret = null
      allowed_audiences = []
    } */

  auth_settings_facebook = null /* {
      app_id = null
      app_secret = null
      oauth_scopes = []
    } */

  auth_settings_google = null /* {
      client_id     = ""
      client_secret = ""
      oauth_scopes  = []
    } */

  auth_settings_microsoft = null /* {
      client_id = null
      client_secret = null 
      oauth_scopes = []
    } */

  connection_strings = [{
    name  = "Database"
    type  = "SQLServer"
    value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }]

  identity = {
    type         = "SystemAssigned"
    identity_ids = null
  }

  site_configs = {
    always_on                        = null
    app_scale_limit                  = null
    dotnet_framework_version         = null
    elastic_instance_minimum         = null
    ftps_state                       = null
    health_check_path                = null
    http2_enabled                    = null
    java_version                     = null
    linux_fx_version                 = null
    min_tls_version                  = null
    pre_warmed_instance_count        = null
    runtime_scale_monitoring_enabled = null
    scm_type                         = null
    scm_use_main_ip_restriction      = null
    use_32_bit_worker_process        = null

    cors = {
      allowed_origins     = ["mypage.html"]
      support_credentials = false
    }
  }

  site_configs_ip_restriction = [/* {
        name                      = null
        ip_address                = null
        service_tag               = null
        virtual_network_subnet_id = null
        action                    = null
        headers = {
          x_azure_fdid      = []
          x_fd_health_probe = []
          x_forwarded_for   = []
          x_forwarded_host  = []
        }
        priority = null    
      } */]

  site_configs_scm_ip_restriction = [/* {
        name                      = null
        ip_address                = null
        service_tag               = null
        virtual_network_subnet_id = null
        action                    = null
        headers = {
          x_azure_fdid      = []
          x_fd_health_probe = []
          x_forwarded_for   = []
          x_forwarded_host  = []
        }
        priority = null    
      } */]

  source_control = null /* {
    repo_url           = "https://vaibhavmalushte@dev.azure.com/vaibhavmalushte/myFirstAzureProject/_git/php_hello_world"
    branch             = "main"
    manual_integration = false
    rollback_enabled   = false
    use_mercurial      = false
  } */

  tags = {
    Environment = "mce"
  }
}

resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = local.location
  tags     = local.tags
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_app_service_plan" "app_service_plan" {
  name                = local.app_service_plan_name
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name

  sku {
    tier = "Medium"
    size = "P2V3"
  }
}

module "storage" {
  source               = "git::https://ava-opscentre.visualstudio.com/Central%20Terraform%20Repo/_git/tf-mce-azurerm-storage-account?ref=v1.0.0"
  storage_account_name = local.storage_account_name
  resource_group_name  = azurerm_resource_group.rg.name
  location             = local.location
  tags                 = local.tags
  account_tier         = var.account_tier
  account_kind         = var.account_kind
}

module "function_app" {
  source = "../"

  function_app_name   = local.function_app_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = local.location
  app_service_plan_id = local.app_service_plan_id

  app_settings                   = local.app_settings
  auth_settings                  = local.auth_settings
  auth_settings_active_directory = local.auth_settings_active_directory
  auth_settings_facebook         = local.auth_settings_facebook
  auth_settings_google           = local.auth_settings_google
  auth_settings_microsoft        = local.auth_settings_microsoft

  connection_strings              = local.connection_strings
  client_affinity_enabled         = local.client_affinity_enabled
  client_cert_mode                = local.client_cert_mode
  daily_memory_time_quota         = local.daily_memory_time_quota
  enabled                         = local.enabled
  enable_builtin_logging          = local.enable_builtin_logging
  https_only                      = local.https_only
  identity                        = local.identity
  os_type                         = local.os_type
  site_configs                    = local.site_configs
  site_configs_ip_restriction     = local.site_configs_ip_restriction
  site_configs_scm_ip_restriction = local.site_configs_scm_ip_restriction
  source_control                  = local.source_control
  storage_account_name            = module.storage.storage_account_name
  storage_account_access_key      = module.storage.storage_primary_access_key
  function_app_version            = local.function_app_version
  tags                            = local.tags
}

output "rg_name" {
  value = azurerm_resource_group.rg.name
}

output "function_app_url" {
  value       = module.function_app.function_app_default_site_hostname
  description = "The Default Hostname associated with the Function App"
}

output "function_app_name" {
  value       = module.function_app.function_app_name
  description = "The Function App name."
}

output "https_only" {
  value       = module.function_app.https_only
  description = "The Function App name."
}