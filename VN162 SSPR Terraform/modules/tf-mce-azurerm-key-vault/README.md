## Descriptions

Terraform module for the creation of a Key Vault.

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
| [azurerm_key_vault.vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |



## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_policy"></a> [access\_policy](#input\_access\_policy) | A list of up to 16 objects describing access policies. A access\_policy block needs to be an object with the following schema:<br><br>&bull; `tenant_id` = string - (Required) The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault. Must match the tenant\_id used above.<br><br>&bull; `object_id` = string - (Required) The object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault. The object ID must be unique for the list of access policies.<br><br>&bull; `application_id` = string - (Optional) The object ID of an Application in Azure Active Directory.<br><br>&bull; `certificate_permissions` = list(string) - (Optional) List of certificate permissions, must be one or more from the following: Backup, Create, Delete, DeleteIssuers, Get, GetIssuers, Import, List, ListIssuers, ManageContacts, ManageIssuers, Purge, Recover, Restore, SetIssuers and Update.<br><br>&bull; `key_permissions` = list(string) - (Optional) List of key permissions, must be one or more from the following: Backup, Create, Decrypt, Delete, Encrypt, Get, Import, List, Purge, Recover, Restore, Sign, UnwrapKey, Update, Verify and WrapKey.<br><br>&bull; `secret_permissions` = list(string) - (Optional) List of secret permissions, must be one or more from the following: Backup, Delete, Get, List, Purge, Recover, Restore and Set.<br><br>&bull; `storage_permissions` = list(string) - (Optional) List of storage permissions, must be one or more from the following: Backup, Delete, DeleteSAS, Get, GetSAS, List, ListSAS, Purge, Recover, RegenerateKey, Restore, Set, SetSAS and Update.<br><br>**NOTE**: If a property above is optional then it needs to be explicitly set to `null` | <pre>list(object({<br>    tenant_id               = string<br>    object_id               = string<br>    application_id          = string<br>    certificate_permissions = list(string)<br>    key_permissions         = list(string)<br>    secret_permissions      = list(string)<br>    storage_permissions     = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_contact"></a> [contact](#input\_contact) | One or more contact block as defined in the following schema:<br><br>&bull; `email` = string - (Required) E-mail address of the contact.<br><br>&bull; `name` = string - (Optional) Name of the contact.<br><br>&bull; `phone` = string - (Optional) Phone number of the contact.<br><br>**NOTE**: This field can only be set once user has `managecontacts` certificate permission. | <pre>list(object({<br>    email = string<br>    name  = string<br>    phone = string<br>  }))</pre> | `[]` | no |
| <a name="input_enable_rbac_authorization"></a> [enable\_rbac\_authorization](#input\_enable\_rbac\_authorization) | Specify whether Azure Key Vault uses Role Based Access Control (RBAC) for authorization of data actions. | `bool` | `false` | no |
| <a name="input_enabled_for_deployment"></a> [enabled\_for\_deployment](#input\_enabled\_for\_deployment) | Specify whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault. | `bool` | `false` | no |
| <a name="input_enabled_for_disk_encryption"></a> [enabled\_for\_disk\_encryption](#input\_enabled\_for\_disk\_encryption) | Specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys. | `bool` | `false` | no |
| <a name="input_enabled_for_template_deployment"></a> [enabled\_for\_template\_deployment](#input\_enabled\_for\_template\_deployment) | Specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault. | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Specifies the name of the Key Vault. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_network_acls"></a> [network\_acls](#input\_network\_acls) | A network\_acls block needs to be an object with the following schema:<br><br>&bull; `bypass` = string - (Required) Specifies which traffic can bypass the network rules. Possible values are AzureServices and None.<br><br>&bull; `default_action` = string - (Required) The Default Action to use when no rules match from ip\_rules / virtual\_network\_subnet\_ids. Possible values are Allow and Deny.<br><br>&bull; `ip_rules` = list(string) - (Optional) One or more IP Addresses, or CIDR Blocks which should be able to access the Key Vault.<br><br>&bull; `virtual_network_subnet_ids` = list(string) - (Optional) One or more Subnet ID's which should be able to access this Key Vault.<br><br>**NOTE**: If a property above is optional then it needs to be explicitly set to `null` | <pre>object({<br>    bypass                     = string<br>    default_action             = string<br>    ip_rules                   = list(string)<br>    virtual_network_subnet_ids = list(string)<br>  })</pre> | `null` | no |
| <a name="input_purge_protection_enabled"></a> [purge\_protection\_enabled](#input\_purge\_protection\_enabled) | Is Purge Protection enabled for this Key Vault? Once Purge Protection has been Enabled it's not possible to Disable it. Support for disabling purge protection is being tracked in an Azure API issue.<br>Deleting the Key Vault with Purge Protection Enabled will schedule the Key Vault to be deleted (which will happen by Azure in the configured number of days, currently 90 days - which will be configurable in Terraform in the future)." | `bool` | `false` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the Key Vault. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | The Name of the SKU used for this Key Vault. Possible values are standard and premium. | `string` | n/a | yes |
| <a name="input_soft_delete_retention_days"></a> [soft\_delete\_retention\_days](#input\_soft\_delete\_retention\_days) | The number of days to retain soft-deleted keys. Can be between 7 and 90. This field can only be configured one time and cannot be updated. | `number` | `90` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_policy"></a> [access\_policy](#output\_access\_policy) | A list of all access policies set on the Key Vault |
| <a name="output_contact"></a> [contact](#output\_contact) | A list of all contacts set on the Key Vault |
| <a name="output_enable_rbac_authorization"></a> [enable\_rbac\_authorization](#output\_enable\_rbac\_authorization) | Boolean specifying whether the Azure Key Vault uses Role Based Access Control (RBAC) for authorization of data actions |
| <a name="output_enabled_for_deployment"></a> [enabled\_for\_deployment](#output\_enabled\_for\_deployment) | Boolean specifying whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault. |
| <a name="output_enabled_for_disk_encryption"></a> [enabled\_for\_disk\_encryption](#output\_enabled\_for\_disk\_encryption) | Boolean specifying whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys. |
| <a name="output_enabled_for_template_deployment"></a> [enabled\_for\_template\_deployment](#output\_enabled\_for\_template\_deployment) | Boolean specifying whether Azure Resource Manager is permitted to retrieve secrets from the key vault. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the Key Vault |
| <a name="output_name"></a> [name](#output\_name) | The name of the Key Vault |
| <a name="output_network_acls"></a> [network\_acls](#output\_network\_acls) | A list of all network acls applied on the key vault |
| <a name="output_purge_protection_enabled"></a> [purge\_protection\_enabled](#output\_purge\_protection\_enabled) | Is Purge Protection enabled for this Key Vault? |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The resource group name of the Key Vault |
| <a name="output_sku_name"></a> [sku\_name](#output\_sku\_name) | The Name of the SKU used for this Key Vault. |
| <a name="output_soft_delete_enabled"></a> [soft\_delete\_enabled](#output\_soft\_delete\_enabled) | Boolean stating whether soft-deleted keys are enabled. |
| <a name="output_soft_delete_retention_days"></a> [soft\_delete\_retention\_days](#output\_soft\_delete\_retention\_days) | The number of days to retain soft-deleted keys. |
| <a name="output_tags"></a> [tags](#output\_tags) | A mapping of tags to assign to the resource. |
| <a name="output_tenant_id"></a> [tenant\_id](#output\_tenant\_id) | The tenant id of the Key Vault |
| <a name="output_vault_uri"></a> [vault\_uri](#output\_vault\_uri) | The URI of the Key Vault |

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
  default = "mce-key-vault-rg"
}

variable "sku" {
  type    = string
  default = "standard"
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
```
