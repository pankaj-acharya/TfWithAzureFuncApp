variable "name" {
  type        = string
  description = "Specifies the name of the Key Vault. Changing this forces a new resource to be created."
}

variable "location" {
  type        = string
  description = "Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the Key Vault. Changing this forces a new resource to be created."
}

variable "sku_name" {
  type        = string
  description = "The Name of the SKU used for this Key Vault. Possible values are standard and premium."
}

variable "tenant_id" {
  type        = string
  description = "The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault."
}

variable "access_policy" {
  type = list(object({
    tenant_id               = string
    object_id               = string
    application_id          = string
    certificate_permissions = list(string)
    key_permissions         = list(string)
    secret_permissions      = list(string)
    storage_permissions     = list(string)
  }))

  description = <<-EOT
  A list of up to 16 objects describing access policies. A access_policy block needs to be an object with the following schema:

  &bull; `tenant_id` = string - (Required) The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault. Must match the tenant_id used above.

  &bull; `object_id` = string - (Required) The object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault. The object ID must be unique for the list of access policies.

  &bull; `application_id` = string - (Optional) The object ID of an Application in Azure Active Directory.

  &bull; `certificate_permissions` = list(string) - (Optional) List of certificate permissions, must be one or more from the following: Backup, Create, Delete, DeleteIssuers, Get, GetIssuers, Import, List, ListIssuers, ManageContacts, ManageIssuers, Purge, Recover, Restore, SetIssuers and Update.

  &bull; `key_permissions` = list(string) - (Optional) List of key permissions, must be one or more from the following: Backup, Create, Decrypt, Delete, Encrypt, Get, Import, List, Purge, Recover, Restore, Sign, UnwrapKey, Update, Verify and WrapKey.

  &bull; `secret_permissions` = list(string) - (Optional) List of secret permissions, must be one or more from the following: Backup, Delete, Get, List, Purge, Recover, Restore and Set.

  &bull; `storage_permissions` = list(string) - (Optional) List of storage permissions, must be one or more from the following: Backup, Delete, DeleteSAS, Get, GetSAS, List, ListSAS, Purge, Recover, RegenerateKey, Restore, Set, SetSAS and Update.

  **NOTE**: If a property above is optional then it needs to be explicitly set to `null`
  EOT

  default = []
}

variable "enabled_for_deployment" {
  type        = bool
  description = "Specify whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault."
  default     = false
}

variable "enabled_for_disk_encryption" {
  type        = bool
  description = "Specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys."
  default     = false
}

variable "enabled_for_template_deployment" {
  type        = bool
  description = "Specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault."
  default     = false
}

variable "enable_rbac_authorization" {
  type        = bool
  description = "Specify whether Azure Key Vault uses Role Based Access Control (RBAC) for authorization of data actions."
  default     = false
}

variable "network_acls" {
  type = object({
    bypass                     = string
    default_action             = string
    ip_rules                   = list(string)
    virtual_network_subnet_ids = list(string)
  })

  description = <<-EOT
  A network_acls block needs to be an object with the following schema:

  &bull; `bypass` = string - (Required) Specifies which traffic can bypass the network rules. Possible values are AzureServices and None.

  &bull; `default_action` = string - (Required) The Default Action to use when no rules match from ip_rules / virtual_network_subnet_ids. Possible values are Allow and Deny.

  &bull; `ip_rules` = list(string) - (Optional) One or more IP Addresses, or CIDR Blocks which should be able to access the Key Vault.

  &bull; `virtual_network_subnet_ids` = list(string) - (Optional) One or more Subnet ID's which should be able to access this Key Vault.

  **NOTE**: If a property above is optional then it needs to be explicitly set to `null`
  EOT

  default = null
}

variable "purge_protection_enabled" {
  type = bool

  description = <<-EOT
  Is Purge Protection enabled for this Key Vault? Once Purge Protection has been Enabled it's not possible to Disable it. Support for disabling purge protection is being tracked in an Azure API issue.
  Deleting the Key Vault with Purge Protection Enabled will schedule the Key Vault to be deleted (which will happen by Azure in the configured number of days, currently 90 days - which will be configurable in Terraform in the future)."
  EOT

  default = false
}

variable "soft_delete_retention_days" {
  type        = number
  description = "The number of days to retain soft-deleted keys. Can be between 7 and 90. This field can only be configured one time and cannot be updated."
  default     = 90
}

variable "contact" {
  type = list(object({
    email = string
    name  = string
    phone = string
  }))

  description = <<-EOT
  One or more contact block as defined in the following schema:

  &bull; `email` = string - (Required) E-mail address of the contact.

  &bull; `name` = string - (Optional) Name of the contact.

  &bull; `phone` = string - (Optional) Phone number of the contact.

  **NOTE**: This field can only be set once user has `managecontacts` certificate permission.
  EOT

  default = []
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource."
  default     = {}
}
