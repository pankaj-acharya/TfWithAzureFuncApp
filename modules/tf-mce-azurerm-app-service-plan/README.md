## Descriptions

Terraform module for the creation of a App Service Plan

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
| [azurerm_app_service_plan.app_service_plan](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_plan) | resource |



## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_service_environment_id"></a> [app\_service\_environment\_id](#input\_app\_service\_environment\_id) | The ID of the App Service Environment where the App Service Plan should be located.<br>**NOTE**: Attaching to an App Service Environment requires the App Service Plan use a Premium SKU (when using an ASEv1) and the Isolated SKU (for an ASEv2). | `string` | `null` | no |
| <a name="input_app_service_plan_name"></a> [app\_service\_plan\_name](#input\_app\_service\_plan\_name) | Specifies the name of the App Service Plan component. | `string` | n/a | yes |
| <a name="input_kind"></a> [kind](#input\_kind) | The kind of the App Service Plan to create. Possible values are `Windows`,`Linux`,`elastic`,`FunctionApp`. Defaults to Windows.<br>    **NOTE**: When creating a Linux App Service Plan, the reserved field must be set to true, and when creating a Windows/app App Service Plan the reserved field must be set to false. | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | Specifies the supported Azure location where the resource exists. | `string` | n/a | yes |
| <a name="input_maximum_elastic_worker_count"></a> [maximum\_elastic\_worker\_count](#input\_maximum\_elastic\_worker\_count) | The maximum number of total workers allowed for this ElasticScaleEnabled App Service Plan. | `string` | n/a | yes |
| <a name="input_per_site_scaling"></a> [per\_site\_scaling](#input\_per\_site\_scaling) | Can Apps assigned to this App Service Plan be scaled independently?<br>**NOTE**:If set to false apps assigned to this plan will scale to all instances of the plan. | `bool` | `false` | no |
| <a name="input_reserved"></a> [reserved](#input\_reserved) | Is this App Service Plan Reserved. | `bool` | `false` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the App Service Plan component. | `string` | n/a | yes |
| <a name="input_sku"></a> [sku](#input\_sku) | A sku block as documented below.<pre>{<br>    tier = string - (Required) Specifies the plan's pricing tier. Accepted values are `B1`,`B2`,`B3`,`D1`,`F1`,`FREE`,`I1`,`I1v2`,`I2`,`I2v2`,`I3`,`I3v2`,`P1V2`,`P1V3`,`P2V2`,`P2V3`,`P3V2`,`P3V3`,`PC2`,`PC3`,`PC4`,`S1`,`S2`,`S3`,`SHARED`<br>    size = string - (Required) Specifies the plan's instance size. Accepted values are `Small`,`Medium` & `Large`<br>    capacity = number - (Optional) Specifies the number of workers associated with this App Service Plan.<br>  }</pre>**NOTE**: If a property above is not needed then it needs to be explicitly set to `null` or `[]` (empty list). | <pre>object({<br>    tier     = string<br>    size     = string<br>    capacity = number<br>  })</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resource. | `map(string)` | n/a | yes |
| <a name="input_zone_redundant"></a> [zone\_redundant](#input\_zone\_redundant) | Specifies if the App Service Plan should be Zone Redundant. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_service_plan_id"></a> [app\_service\_plan\_id](#output\_app\_service\_plan\_id) | The ID of the App Service Plan. |
| <a name="output_app_service_plan_maximum_number_of_workers"></a> [app\_service\_plan\_maximum\_number\_of\_workers](#output\_app\_service\_plan\_maximum\_number\_of\_workers) | The maximum number of workers supported with the App Service Plan's sku. |
| <a name="output_app_service_plan_name"></a> [app\_service\_plan\_name](#output\_app\_service\_plan\_name) | The name of the App Service Plan component. |

## Example

```hcl
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
```
