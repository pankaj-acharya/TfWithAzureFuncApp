/**
  * ## Descriptions
  * 
  * Terraform module for the creation of a Key Vault Key. 
  *
  */

resource "azurerm_key_vault_key" "key" {
  name            = var.key_name
  key_vault_id    = var.key_vault_id
  key_type        = var.key_type
  key_size        = var.key_size
  curve           = var.key_curve
  key_opts        = var.key_operations
  not_before_date = var.not_before_date
  expiration_date = var.expiration_date
  tags            = var.tags
}