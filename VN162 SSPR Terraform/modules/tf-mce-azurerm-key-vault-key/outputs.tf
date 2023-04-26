output "key_id" {
  description = "The Key Vault Key ID."
  value       = azurerm_key_vault_key.key.id
}

output "key_name" {
  description = "The Key Vault Key name."
  value       = azurerm_key_vault_key.key.name
}

output "key_version" {
  description = "The current version of the Key Vault Key."
  value       = azurerm_key_vault_key.key.version
}

output "key_versionless_id" {
  description = "The Base ID of the Key Vault Key."
  value       = azurerm_key_vault_key.key.versionless_id
}

output "rsa_modulus" {
  description = "The RSA modulus of this Key Vault Key."
  value       = azurerm_key_vault_key.key.n
}

output "rsa_public_exponent" {
  description = "The RSA public exponent of this Key Vault Key."
  value       = azurerm_key_vault_key.key.e
}

output "ec_x_component" {
  description = "The EC X component of this Key Vault Key."
  value       = azurerm_key_vault_key.key.x
}

output "ec_y_component" {
  description = "The EC Y component of this Key Vault Key."
  value       = azurerm_key_vault_key.key.y
}