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

variable "location" {
  type    = string
  default = "uksouth"
}

variable "resource_group_name" {
  type    = string
  default = "mce-keyvault-rg"
}

variable "postfix" {
  type    = string
  default = "mce"
}

locals {
  key_name = "verysecretkey"
  key_vault = {
    name                = format("%s%s", "mce-kvault", var.postfix)
    location            = "uksouth"
    resource_group_name = "rg-name"
    resource_location   = "uksouth"
    sku                 = "standard"
    tags = {
      Environment = "DEV"
    }
    enabled_for_disk_encryption     = true
    enabled_for_template_deployment = null
    enabled_for_deployment          = true
    soft_delete_retention_days      = null
    purge_protection_enabled        = false
    access_control_default_action   = "Allow"
    access_control_bypass           = "AzureServices"
    access_control_ip_rule          = []
    access_control_subnet_id        = null
  }
  access_policies = [
    {
      object_id               = data.azurerm_client_config.current.object_id
      application_id          = null
      secret_permissions      = ["Get", "Purge", "Delete"]
      key_permissions         = ["Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey"]
      certificate_permissions = ["Backup", "Update", "Import"]
      storage_permissions     = []
    }
  ]

  keys = [
    {
      key_name        = local.key_name
      key_type        = "RSA"
      key_size        = 2048
      key_curve       = null
      key_operations  = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]
      not_before_date = null
      expiration_date = null
    }
  ]
}

data "azurerm_client_config" "current" {
}

resource "azurerm_resource_group" "rg" {
  name     = "kvtest"
  location = local.key_vault.location
  tags     = local.key_vault.tags
}

resource "azurerm_key_vault" "key_vault" {
  name                            = local.key_vault.name
  location                        = local.key_vault.location
  resource_group_name             = azurerm_resource_group.rg.name
  tags                            = local.key_vault.tags
  enabled_for_disk_encryption     = local.key_vault.enabled_for_disk_encryption
  enabled_for_template_deployment = local.key_vault.enabled_for_template_deployment
  enabled_for_deployment          = local.key_vault.enabled_for_deployment
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days      = local.key_vault.soft_delete_retention_days
  purge_protection_enabled        = local.key_vault.purge_protection_enabled
  sku_name                        = local.key_vault.sku

  network_acls {
    default_action             = local.key_vault.access_control_default_action
    bypass                     = local.key_vault.access_control_bypass
    ip_rules                   = local.key_vault.access_control_ip_rule
    virtual_network_subnet_ids = local.key_vault.access_control_subnet_id
  }
}

resource "azurerm_key_vault_access_policy" "access_policy" {
  for_each                = { for access_policies in toset(local.access_policies) : access_policies.object_id => access_policies }
  key_vault_id            = azurerm_key_vault.key_vault.id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = each.key
  application_id          = each.value.application_id
  secret_permissions      = each.value.secret_permissions
  key_permissions         = each.value.key_permissions
  certificate_permissions = each.value.certificate_permissions
  storage_permissions     = each.value.storage_permissions
}

module "keys" {
  # Hard dependency here as no opportunity for implicit
  depends_on      = [azurerm_key_vault_access_policy.access_policy]
  source          = "../"
  for_each        = { for key in toset(local.keys) : key.key_name => key }
  key_vault_id    = azurerm_key_vault.key_vault.id
  tags            = local.key_vault.tags
  key_name        = each.key
  key_type        = each.value.key_type
  key_size        = each.value.key_size
  key_curve       = each.value.key_curve
  key_operations  = each.value.key_operations
  not_before_date = each.value.not_before_date
  expiration_date = each.value.expiration_date
}

output "key_name" {
  value = module.keys[local.key_name].key_name
}

output "key_vault_name" {
  value = azurerm_key_vault.key_vault.name
}
