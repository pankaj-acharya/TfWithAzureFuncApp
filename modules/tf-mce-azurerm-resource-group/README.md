## Descriptions

Terraform module for the creation of a Resource Group.

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
| [azurerm_resource_group.resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |



## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | The location/region where the resources will be created. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the Resource Group. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resources. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the Resource Group. |
| <a name="output_name"></a> [name](#output\_name) | The name of the Resource Group. |

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
```
