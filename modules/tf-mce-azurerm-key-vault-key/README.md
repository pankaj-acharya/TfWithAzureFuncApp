## Descriptions

Terraform module for the creation of a Key Vault Key.

## Requirements

No requirements.

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault_key.key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) | resource |



## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_expiration_date"></a> [expiration\_date](#input\_expiration\_date) | Expiration UTC datetime (Y-m-d'T'H:M:S'Z'). | `string` | `null` | no |
| <a name="input_key_curve"></a> [key\_curve](#input\_key\_curve) | Specifies the curve to use when creating an EC key. Possible values are `P-256`, `P-256K`, `P-384`, and `P-521`. <br><br>This field will be required in a future release if key\_type is `EC` or `EC-HSM`. The API will default to `P-256` if nothing is specified. | `string` | `null` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | The name of the Key Vault Key. | `string` | n/a | yes |
| <a name="input_key_operations"></a> [key\_operations](#input\_key\_operations) | A list of JSON web key operations. Possible values include: `decrypt`, `encrypt`, `sign`, `unwrapKey`, `verify` and `wrapKey`.<br><br>**Note**: Please note these values are case sensitive. | `list(string)` | n/a | yes |
| <a name="input_key_size"></a> [key\_size](#input\_key\_size) | Specifies the Size of the RSA key to create in bytes. For example, `1024` or `2048`.<br><br>**Note**: This field is required if key\_type is `RSA` or `RSA-HSM`. Changing this forces a new resource to be created. | `number` | `null` | no |
| <a name="input_key_type"></a> [key\_type](#input\_key\_type) | Specifies the Key Type to use for this Key Vault Key. Possible values are `EC` (Elliptic Curve), `EC-HSM`, `Oct` (Octet), `RSA` and `RSA-HSM`. | `string` | n/a | yes |
| <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id) | The ID of the Key Vault where this key should be created. | `string` | n/a | yes |
| <a name="input_not_before_date"></a> [not\_before\_date](#input\_not\_before\_date) | Key not usable before the provided UTC datetime (Y-m-d'T'H:M:S'Z'). | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ec_x_component"></a> [ec\_x\_component](#output\_ec\_x\_component) | The EC X component of this Key Vault Key. |
| <a name="output_ec_y_component"></a> [ec\_y\_component](#output\_ec\_y\_component) | The EC Y component of this Key Vault Key. |
| <a name="output_key_id"></a> [key\_id](#output\_key\_id) | The Key Vault Key ID. |
| <a name="output_key_name"></a> [key\_name](#output\_key\_name) | The Key Vault Key name. |
| <a name="output_key_version"></a> [key\_version](#output\_key\_version) | The current version of the Key Vault Key. |
| <a name="output_key_versionless_id"></a> [key\_versionless\_id](#output\_key\_versionless\_id) | The Base ID of the Key Vault Key. |
| <a name="output_rsa_modulus"></a> [rsa\_modulus](#output\_rsa\_modulus) | The RSA modulus of this Key Vault Key. |
| <a name="output_rsa_public_exponent"></a> [rsa\_public\_exponent](#output\_rsa\_public\_exponent) | The RSA public exponent of this Key Vault Key. |

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

variable "resource_group_name" {
  type    = string
  default = "mce-keyvault-rg"
}

variable "postfix" {
  type    = string
  default = "mce"
}

locals {
  key_name = "verysecretkey"
  key_vault = {
    name                = format("%s%s", "mce-kvault", var.postfix)
    location            = "uksouth"
    resource_group_name = "rg-name"
    resource_location   = "uksouth"
    sku                 = "standard"
    tags = {
      Environment = "DEV"
    }
    enabled_for_disk_encryption     = true
    enabled_for_template_deployment = null
    enabled_for_deployment          = true
    soft_delete_retention_days      = null
    purge_protection_enabled        = false
    access_control_default_action   = "Allow"
    access_control_bypass           = "AzureServices"
    access_control_ip_rule          = []
    access_control_subnet_id        = null
  }
  access_policies = [
    {
      object_id               = data.azurerm_client_config.current.object_id
      application_id          = null
      secret_permissions      = ["Get", "Purge", "Delete"]
      key_permissions         = ["Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey"]
      certificate_permissions = ["Backup", "Update", "Import"]
      storage_permissions     = []
    }
  ]

  keys = [
    {
      key_name        = local.key_name
      key_type        = "RSA"
      key_size        = 2048
      key_curve       = null
      key_operations  = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]
      not_before_date = null
      expiration_date = null
    }
  ]
}

data "azurerm_client_config" "current" {
}

resource "azurerm_resource_group" "rg" {
  name     = "kvtest"
  location = local.key_vault.location
  tags     = local.key_vault.tags
}

resource "azurerm_key_vault" "key_vault" {
  name                            = local.key_vault.name
  location                        = local.key_vault.location
  resource_group_name             = azurerm_resource_group.rg.name
  tags                            = local.key_vault.tags
  enabled_for_disk_encryption     = local.key_vault.enabled_for_disk_encryption
  enabled_for_template_deployment = local.key_vault.enabled_for_template_deployment
  enabled_for_deployment          = local.key_vault.enabled_for_deployment
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days      = local.key_vault.soft_delete_retention_days
  purge_protection_enabled        = local.key_vault.purge_protection_enabled
  sku_name                        = local.key_vault.sku

  network_acls {
    default_action             = local.key_vault.access_control_default_action
    bypass                     = local.key_vault.access_control_bypass
    ip_rules                   = local.key_vault.access_control_ip_rule
    virtual_network_subnet_ids = local.key_vault.access_control_subnet_id
  }
}

resource "azurerm_key_vault_access_policy" "access_policy" {
  for_each                = { for access_policies in toset(local.access_policies) : access_policies.object_id => access_policies }
  key_vault_id            = azurerm_key_vault.key_vault.id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = each.key
  application_id          = each.value.application_id
  secret_permissions      = each.value.secret_permissions
  key_permissions         = each.value.key_permissions
  certificate_permissions = each.value.certificate_permissions
  storage_permissions     = each.value.storage_permissions
}

module "keys" {
  # Hard dependency here as no opportunity for implicit
  depends_on      = [azurerm_key_vault_access_policy.access_policy]
  source          = "../"
  for_each        = { for key in toset(local.keys) : key.key_name => key }
  key_vault_id    = azurerm_key_vault.key_vault.id
  tags            = local.key_vault.tags
  key_name        = each.key
  key_type        = each.value.key_type
  key_size        = each.value.key_size
  key_curve       = each.value.key_curve
  key_operations  = each.value.key_operations
  not_before_date = each.value.not_before_date
  expiration_date = each.value.expiration_date
}

output "key_name" {
  value = module.keys[local.key_name].key_name
}

output "key_vault_name" {
  value = azurerm_key_vault.key_vault.name
}

```
