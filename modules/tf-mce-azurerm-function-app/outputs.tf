output "id" {
  value       = azurerm_function_app.function_app.id
  description = "The ID of the Function App."
}

output "function_app_custom_domain_verification_id" {
  value       = azurerm_function_app.function_app.custom_domain_verification_id
  description = "An identifier used by Function App to perform domain ownership verification via DNS TXT record."
}

output "function_app_default_site_hostname" {
  value       = azurerm_function_app.function_app.default_hostname
  description = "The Default Hostname associated with the Function App - such as mysite.azurewebsites.net"
}

output "function_app_outbound_ip_addresses" {
  value       = azurerm_function_app.function_app.outbound_ip_addresses
  description = "A comma separated list of outbound IP addresses."
}

output "function_app_possible_outbound_ip_addresses" {
  value       = azurerm_function_app.function_app.possible_outbound_ip_addresses
  description = "A comma separated list of outbound IP addresses"
}

output "function_app_source_control" {
  value       = azurerm_function_app.function_app.source_control
  description = "A Source Control information when scm_type is set to LocalGit"
}

output "function_app_identity" {
  value       = azurerm_function_app.function_app.identity
  description = "An Managed Service Identity information for this Function App."
  sensitive   = true
}

output "function_app_site_credential" {
  value       = azurerm_function_app.function_app.site_credential
  description = "The username & password which can be used to publish to this Function App."
  sensitive   = true
}

output "function_app_name" {
  value       = azurerm_function_app.function_app.name
  description = "The name of the Function App."
}

output "https_only" {
  value       = azurerm_function_app.function_app.https_only
  description = "The Function HTTP Only."
}