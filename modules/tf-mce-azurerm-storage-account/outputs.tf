output "storage_account_id" {
  value       = azurerm_storage_account.storage_account.id
  description = "The ID of the Storage Account."
}

output "storage_account_name" {
  value       = azurerm_storage_account.storage_account.name
  description = "The name of the Storage Account."
}

output "storage_primary_connection_string" {
  value       = azurerm_storage_account.storage_account.primary_connection_string
  description = "The primary connection string for the Storage Account associated with the primary location."
  sensitive   = true
}

output "storage_primary_access_key" {
  value       = azurerm_storage_account.storage_account.primary_access_key
  description = "The primary access key for the Storage Account."
  sensitive   = true
}

output "storage_primary_blob_endpoint" {
  value       = azurerm_storage_account.storage_account.primary_blob_endpoint
  description = "The endpoint url for Blob Storage in the primary location."
}

output "storage_primary_web_host" {
  value       = azurerm_storage_account.storage_account.primary_web_host
  description = "The hostname with port if applicable for Web Storage in the primary location."
}