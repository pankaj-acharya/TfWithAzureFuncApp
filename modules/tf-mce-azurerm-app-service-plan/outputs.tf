output "app_service_plan_id" {
  value       = azurerm_app_service_plan.app_service_plan.id
  description = "The ID of the App Service Plan."
}

output "app_service_plan_name" {
  value       = var.app_service_plan_name
  description = "The name of the App Service Plan component."
}

output "app_service_plan_maximum_number_of_workers" {
  value       = azurerm_app_service_plan.app_service_plan.maximum_number_of_workers
  description = "The maximum number of workers supported with the App Service Plan's sku."
}
 