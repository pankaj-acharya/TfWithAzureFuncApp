output "id" {
  value       = azurerm_key_vault.vault.id
  description = "The ID of the Key Vault"
}

output "name" {
  value       = azurerm_key_vault.vault.name
  description = "The name of the Key Vault"
}

output "vault_uri" {
  value       = azurerm_key_vault.vault.vault_uri
  description = "The URI of the Key Vault"
}

output "resource_group_name" {
  value       = azurerm_key_vault.vault.resource_group_name
  description = "The resource group name of the Key Vault"
}

output "tenant_id" {
  value       = azurerm_key_vault.vault.tenant_id
  description = "The tenant id of the Key Vault"
}

output "access_policy" {
  value       = azurerm_key_vault.vault.access_policy
  description = "A list of all access policies set on the Key Vault"
}

output "contact" {
  value       = azurerm_key_vault.vault.contact
  description = "A list of all contacts set on the Key Vault"
}

output "enable_rbac_authorization" {
  value       = azurerm_key_vault.vault.enable_rbac_authorization
  description = "Boolean specifying whether the Azure Key Vault uses Role Based Access Control (RBAC) for authorization of data actions"
}

output "enabled_for_deployment" {
  value       = azurerm_key_vault.vault.enabled_for_deployment
  description = "Boolean specifying whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault."
}

output "enabled_for_disk_encryption" {
  value       = azurerm_key_vault.vault.enabled_for_disk_encryption
  description = "Boolean specifying whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys."
}

output "enabled_for_template_deployment" {
  value       = azurerm_key_vault.vault.enabled_for_template_deployment
  description = "Boolean specifying whether Azure Resource Manager is permitted to retrieve secrets from the key vault."
}

output "network_acls" {
  value       = azurerm_key_vault.vault.network_acls
  description = "A list of all network acls applied on the key vault"
}

output "purge_protection_enabled" {
  value       = azurerm_key_vault.vault.purge_protection_enabled
  description = "Is Purge Protection enabled for this Key Vault?"
}

output "sku_name" {
  value       = azurerm_key_vault.vault.sku_name
  description = "The Name of the SKU used for this Key Vault."
}

output "soft_delete_enabled" {
  value       = azurerm_key_vault.vault.soft_delete_enabled
  description = "Boolean stating whether soft-deleted keys are enabled."
}

output "soft_delete_retention_days" {
  value       = azurerm_key_vault.vault.soft_delete_retention_days
  description = "The number of days to retain soft-deleted keys."
}

output "tags" {
  value       = azurerm_key_vault.vault.tags
  description = "A mapping of tags to assign to the resource."
}