/**
  * ## Descriptions
  * 
  * Terraform module for the creation of an Application Insights instance, with an option for creating it in Classic or Workspace mode. workspace_id is required to create an Application Insights instance in Workspace mode.
  *
  */

resource "azurerm_application_insights" "application_insights" {
  name                                  = var.name
  location                              = var.location
  resource_group_name                   = var.resource_group_name
  application_type                      = var.application_type
  retention_in_days                     = var.retention_in_days
  daily_data_cap_in_gb                  = var.daily_data_cap_in_gb
  daily_data_cap_notifications_disabled = var.daily_data_cap_notifications_disabled
  sampling_percentage                   = var.sampling_percentage
  disable_ip_masking                    = var.disable_ip_masking
  workspace_id                          = var.workspace_id
  local_authentication_disabled         = var.local_authentication_disabled
  internet_ingestion_enabled            = var.internet_ingestion_enabled
  internet_query_enabled                = var.internet_query_enabled
  tags                                  = var.tags
}