terraform {
  required_version = "=1.0.7"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.86.0"
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
  default = "mce-application-insights-rg"
}

variable "application_insights_name" {
  type    = string
  default = "mce-application-insights"
}

locals {
  location                  = var.location
  resource_group_name       = format("%s-%s", var.resource_group_name, var.postfix)
  application_insights_name = format("%s-%s", var.application_insights_name, var.postfix)
  tags = {
    Environment = "mce"
  }

  applicationinsights = [{
    name                                  = local.application_insights_name
    location                              = local.location
    resource_group_name                   = azurerm_resource_group.rg.name
    application_type                      = "web"
    retention_in_days                     = null
    daily_data_cap_in_gb                  = null
    daily_data_cap_notifications_disabled = null
    sampling_percentage                   = null
    disable_ip_masking                    = false
    workspace_id                          = azurerm_log_analytics_workspace.log_analytics_workspace.id
    local_authentication_disabled         = false
    internet_ingestion_enabled            = null
    internet_query_enabled                = true
    tags                                  = local.tags
  }]
}

resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = local.location
  tags     = local.tags
}

resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                              = format("%s-%s", "log-analytics", var.postfix)
  location                          = local.location
  resource_group_name               = azurerm_resource_group.rg.name
  sku                               = "PerGB2018"
  retention_in_days                 = 30
  internet_ingestion_enabled        = true
  reservation_capcity_in_gb_per_day = null
  daily_quota_gb                    = null
  tags                              = local.tags
}

module "application_insights" {
  source                                = "../"
  for_each                              = { for insights in toset(local.applicationinsights) : insights.name => insights }
  name                                  = each.key
  location                              = each.value.location
  resource_group_name                   = each.value.resource_group_name
  application_type                      = each.value.application_type
  retention_in_days                     = each.value.retention_in_days
  daily_data_cap_in_gb                  = each.value.daily_data_cap_in_gb
  daily_data_cap_notifications_disabled = each.value.daily_data_cap_notifications_disabled
  sampling_percentage                   = each.value.sampling_percentage
  disable_ip_masking                    = each.value.disable_ip_masking
  workspace_id                          = each.value.workspace_id
  local_authentication_disabled         = each.value.local_authentication_disabled
  internet_ingestion_enabled            = each.value.internet_ingestion_enabled
  internet_query_enabled                = each.value.internet_query_enabled
  tags                                  = each.value.tags
}

output "application_insights_id" {
  value = module.application_insights[local.application_insights_name].id
}