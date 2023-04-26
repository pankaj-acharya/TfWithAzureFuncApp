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
  type        = string
  description = "The location/region where the resources will be created."
  default     = "uksouth"
}

variable "resource_group_name" {
  type    = string
  default = "mce-resource-group-rg"
}

variable "postfix" {
  type    = string
  default = "mce"
}

locals {
  location            = var.location
  resource_group_name = format("%s-%s", var.resource_group_name, var.postfix)
  tags = {
    Environment = "mce"
  }
  resource_groups = [
    {
      resource_group_name = local.resource_group_name
      location            = local.location
      tags                = local.tags
    }
  ]
}

module "rg" {
  source   = "../"
  for_each = { for rg in toset(local.resource_groups) : rg.resource_group_name => rg }
  name     = each.key
  location = each.value.location
  tags     = each.value.tags
}

output "resource_group_name" {
  value = module.rg[local.resource_group_name].name
}
