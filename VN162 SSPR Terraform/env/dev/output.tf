output "functions_storage_account_name" {
  value = module.storage["001"].storage_account_name
}

output "function_app_name" {
  value       = module.function_app.function_app_name
  description = "The Function App name."
}