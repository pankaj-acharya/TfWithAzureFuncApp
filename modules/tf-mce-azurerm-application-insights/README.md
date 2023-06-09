## Descriptions

Terraform module for the creation of an Application Insights instance, with an option for creating it in Classic or Workspace mode. workspace\_id is required to create an Application Insights instance in Workspace mode.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.0.7 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=2.73.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_application_insights.application_insights](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights) | resource |



## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_type"></a> [application\_type](#input\_application\_type) | Specifies the type of Application Insights Instance to create. Valid values are `ios for iOS`, `java for Java web`, `MobileCenter for App Center`, `Node.JS for Node`, `other for General`, `phone for Windows Phone`, `store for Windows Store` and `web for ASP.NET`. These values are case sensitive; unmatched values are treated as ASP.NET by Azure. | `string` | n/a | yes |
| <a name="input_daily_data_cap_in_gb"></a> [daily\_data\_cap\_in\_gb](#input\_daily\_data\_cap\_in\_gb) | Specifies the Application Insights component daily data volume cap in GB. | `number` | `null` | no |
| <a name="input_daily_data_cap_notifications_disabled"></a> [daily\_data\_cap\_notifications\_disabled](#input\_daily\_data\_cap\_notifications\_disabled) | Specifies if a notification email will be send when the daily data volume cap is met. | `bool` | `null` | no |
| <a name="input_disable_ip_masking"></a> [disable\_ip\_masking](#input\_disable\_ip\_masking) | By default the real client ip is masked as `0.0.0.0` in the logs. Use this argument to disable masking and log the real client ip. | `bool` | `false` | no |
| <a name="input_internet_ingestion_enabled"></a> [internet\_ingestion\_enabled](#input\_internet\_ingestion\_enabled) | Should the Application Insights component support ingestion over the Public Internet? | `bool` | `true` | no |
| <a name="input_internet_query_enabled"></a> [internet\_query\_enabled](#input\_internet\_query\_enabled) | Should the Application Insights component support querying over the Public Internet? | `bool` | `true` | no |
| <a name="input_local_authentication_disabled"></a> [local\_authentication\_disabled](#input\_local\_authentication\_disabled) | Disable Non-Azure AD based Auth. | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | The location/region where the resources will be created. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Specifies the name of the Application Insights component. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the Resource Group where the resources will be created. | `string` | n/a | yes |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days) | Specifies the retention period in days. Possible values are `30`, `60`, `90`, `120`, `180`, `270`, `365`, `550` or `730`. | `number` | `90` | no |
| <a name="input_sampling_percentage"></a> [sampling\_percentage](#input\_sampling\_percentage) | Specifies the percentage of the data produced by the monitored application that is sampled for Application Insights telemetry. | `number` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource. | `map(string)` | n/a | yes |
| <a name="input_workspace_id"></a> [workspace\_id](#input\_workspace\_id) | Specifies the id of a log analytics workspace resource. This is required to create an Application Insights instance in Workspace mode. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_id"></a> [app\_id](#output\_app\_id) | The App ID associated with this Application Insights component. |
| <a name="output_connection_string"></a> [connection\_string](#output\_connection\_string) | The Connection String for this Application Insights component. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the Application Insights component. |
| <a name="output_instrumentation_key"></a> [instrumentation\_key](#output\_instrumentation\_key) | The Instrumentation Key for this Application Insights component. |
| <a name="output_name"></a> [name](#output\_name) | The name of the Application Insights component. |

## Example

```hcl
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
```
