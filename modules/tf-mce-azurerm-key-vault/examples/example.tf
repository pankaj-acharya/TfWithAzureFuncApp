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

variable "postfix" {
  type    = string
  default = "mce"
}

variable "resource_group_name" {
  type    = string
  default = "mce-key-vault-rg"
}

locals {
  location            = var.location
  resource_group_name = format("%s-%s", var.resource_group_name, var.postfix)
  key_vault_name      = format("%s-%s", "mce-tst-key-vault", var.postfix)
  tags = {
    Environment = "mce"
  }

  key_vaults = {
    "${local.key_vault_name}" = {
      location                    = local.location
      resource_group_name         = azurerm_resource_group.rg.name
      sku_name                    = "standard"
      tenant_id                   = data.azurerm_client_config.current.tenant_id
      enabled_for_disk_encryption = true
      purge_protection_enabled    = false
      soft_delete_retention_days  = 7

      access_policy = [
        {
          tenant_id               = data.azurerm_client_config.current.tenant_id
          object_id               = data.azurerm_client_config.current.object_id
          application_id          = null
          certificate_permissions = null

          key_permissions = [
            "Get",
          ]

          secret_permissions = [
            "Get",
          ]

          storage_permissions = [
            "Get",
          ]
        }
      ]

      tags = local.tags
    }
  }
}

resource "random_integer" "suffix" {
  min = 10000
  max = 99999
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = local.location
  tags     = local.tags
}

module "key_vault" {
  source   = "../"
  for_each = local.key_vaults

  name                        = each.key
  location                    = each.value.location
  resource_group_name         = each.value.resource_group_name
  sku_name                    = each.value.sku_name
  tenant_id                   = each.value.tenant_id
  enabled_for_disk_encryption = each.value.enabled_for_disk_encryption
  purge_protection_enabled    = each.value.purge_protection_enabled
  soft_delete_retention_days  = each.value.soft_delete_retention_days
  access_policy               = each.value.access_policy
  tags                        = each.value.tags
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "keyvault_name" {
  value = module.key_vault["${local.key_vault_name}"].name
}

output "keyvault_uri" {
  value = module.key_vault["${local.key_vault_name}"].vault_uri
}

output "keyvault_id" {
  value = module.key_vault["${local.key_vault_name}"].id
}

output "keyvault_resource_group_name" {
  value = module.key_vault["${local.key_vault_name}"].resource_group_name
}

output "keyvault_tenant_id" {
  value = module.key_vault["${local.key_vault_name}"].tenant_id
}

output "access_policy" {
  value = module.key_vault["${local.key_vault_name}"].access_policy
}

output "enable_rbac_authorization" {
  value = module.key_vault["${local.key_vault_name}"].enable_rbac_authorization
}

output "sku_name" {
  value = module.key_vault["${local.key_vault_name}"].sku_name
}
