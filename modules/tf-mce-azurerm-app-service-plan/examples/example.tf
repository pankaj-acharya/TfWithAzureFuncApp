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
  default = "mce-web-app-rg"
}

variable "app_service_plan_name" {
  type    = string
  default = "mce-web-app-service-plan"
}

locals {
  app_service_plan_name        = format("%s-%s", var.app_service_plan_name, var.postfix)
  resource_group_name          = format("%s-%s", var.resource_group_name, var.postfix)
  location                     = var.location
  kind                         = "Windows"
  maximum_elastic_worker_count = 1
  app_service_environment_id = null
  reserved                   = false
  per_site_scaling           = false
  zone_redundant             = false

  sku = {
    tier     = "Free"
    size     = "F1"
    capacity = null
  }

  tags = {
    Environment = "mce"
  }
}

resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = local.location
  tags     = local.tags
}

module "app_service_plan" {
  source                       = "../"
  app_service_plan_name        = local.app_service_plan_name
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = local.location
  kind                         = local.kind
  maximum_elastic_worker_count = local.maximum_elastic_worker_count
  sku                          = local.sku
  app_service_environment_id   = local.app_service_environment_id
  reserved                     = local.reserved
  per_site_scaling             = local.per_site_scaling
  zone_redundant               = local.zone_redundant
  tags                         = local.tags
}

output "rg_name" {
  value = azurerm_resource_group.rg.name
}

output "app_service_plan_id" {
  value       = module.app_service_plan.app_service_plan_id
  description = "The App Service Plan ID."
}

output "app_service_plan_maximum_number_of_workers" {
  value       = module.app_service_plan.app_service_plan_maximum_number_of_workers
  description = "The App Service Plan ID."
}

output "app_service_plan_name" {
  value       = module.app_service_plan.app_service_plan_name
  description = "The name of the App Service Plan component."
}