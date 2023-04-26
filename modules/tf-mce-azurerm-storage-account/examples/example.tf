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
  default = "mce-storage-rg"
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

locals {
  resource_group_name  = format("%s-%s", var.resource_group_name, var.postfix)
  storage_account_name = lower(format("%s%s", var.storage_account_name, var.postfix))
  storage_accounts = {
    "001" = {
      storage_account_name = local.storage_account_name
      resource_group_name  = azurerm_resource_group.rg.name
      location             = local.location
      tags                 = local.tags
      account_tier         = var.account_tier
      account_kind         = var.account_kind
    }
  }
  location = var.location
  tags = {
    Environment = "ntc"
  }
}

resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = local.location
  tags     = local.tags
}

module "storage" {
  for_each             = local.storage_accounts
  source               = "../"
  storage_account_name = local.storage_account_name
  resource_group_name  = azurerm_resource_group.rg.name
  location             = local.location
  tags                 = local.tags
  account_tier         = var.account_tier
  account_kind         = var.account_kind
}

output "rg_name" {
  value = azurerm_resource_group.rg.name
}

output "storage_account_name" {
  value = module.storage["001"].storage_account_name
}

output "account_tier" {
  value = var.account_tier
}

output "account_kind" {
  value = var.account_kind
}