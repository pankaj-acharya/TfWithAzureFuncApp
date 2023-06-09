## Descriptions

Terraform module for the creation of a Storage Account.

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
| [azurerm_storage_account.storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |



## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_tier"></a> [access\_tier](#input\_access\_tier) | Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts. Valid options are Hot and Cool, defaults to Hot. | `string` | `"Hot"` | no |
| <a name="input_account_kind"></a> [account\_kind](#input\_account\_kind) | The kind of Storage Acccount. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2. | `string` | `"StorageV2"` | no |
| <a name="input_account_replication_type"></a> [account\_replication\_type](#input\_account\_replication\_type) | Defines the type of replication to use for this Storage Account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS. | `string` | `"LRS"` | no |
| <a name="input_account_tier"></a> [account\_tier](#input\_account\_tier) | Defined the Tier to use for this storage account. Valid options are Standard and Premium. For BlockBlockStorage and FileStorage accounts only Premium is valid. | `string` | `"Standard"` | no |
| <a name="input_enable_https_traffic_only"></a> [enable\_https\_traffic\_only](#input\_enable\_https\_traffic\_only) | Boolean flag which forces HTTPS if enabled. Defaults to true. | `bool` | `true` | no |
| <a name="input_hns_enabled"></a> [hns\_enabled](#input\_hns\_enabled) | Do you need Hierarchical NameSpace enabled. This is for DataLake Gen2 deployments. | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | The location/region where the resource will be created. | `string` | n/a | yes |
| <a name="input_min_tls_version"></a> [min\_tls\_version](#input\_min\_tls\_version) | The minimum supported TLS version for the Storage Account. Possible values are TLS1\_0, TLS1\_1, and TLS1\_2. | `string` | `"TLS1_2"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the Resource Group in which the Storage Account is created. | `string` | n/a | yes |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | The name of the Azure Storage Account. Name must be globally unique. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resource. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_storage_account_id"></a> [storage\_account\_id](#output\_storage\_account\_id) | The ID of the Storage Account. |
| <a name="output_storage_account_name"></a> [storage\_account\_name](#output\_storage\_account\_name) | The name of the Storage Account. |
| <a name="output_storage_primary_access_key"></a> [storage\_primary\_access\_key](#output\_storage\_primary\_access\_key) | The primary access key for the Storage Account. |
| <a name="output_storage_primary_blob_endpoint"></a> [storage\_primary\_blob\_endpoint](#output\_storage\_primary\_blob\_endpoint) | The endpoint url for Blob Storage in the primary location. |
| <a name="output_storage_primary_connection_string"></a> [storage\_primary\_connection\_string](#output\_storage\_primary\_connection\_string) | The primary connection string for the Storage Account associated with the primary location. |
| <a name="output_storage_primary_web_host"></a> [storage\_primary\_web\_host](#output\_storage\_primary\_web\_host) | The hostname with port if applicable for Web Storage in the primary location. |

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
```
