output "id" {
  value       = azurerm_application_insights.application_insights.id
  description = "The ID of the Application Insights component."
}

output "name" {
  value       = azurerm_application_insights.application_insights.name
  description = "The name of the Application Insights component."
}

output "app_id" {
  value       = azurerm_application_insights.application_insights.app_id
  description = "The App ID associated with this Application Insights component."
}

output "instrumentation_key" {
  value       = azurerm_application_insights.application_insights.instrumentation_key
  description = "The Instrumentation Key for this Application Insights component."
  sensitive   = true
}

output "connection_string" {
  value       = azurerm_application_insights.application_insights.connection_string
  description = "The Connection String for this Application Insights component."
  sensitive   = true
}