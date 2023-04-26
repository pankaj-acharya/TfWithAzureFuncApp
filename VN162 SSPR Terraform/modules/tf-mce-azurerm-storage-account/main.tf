/**
  * ## Descriptions
  * 
  * Terraform module for the creation of a Storage Account.
  *
  */

resource "azurerm_storage_account" "storage_account" {
  name                      		= lower(var.storage_account_name)
  resource_group_name       		= var.resource_group_name
  location                  		= var.location
  account_kind              		= var.account_kind
  account_tier              		= var.account_tier
  account_replication_type  		= var.account_replication_type
  access_tier               		= var.access_tier
  enable_https_traffic_only 		= var.enable_https_traffic_only
  is_hns_enabled            		= var.hns_enabled
  min_tls_version           		= var.min_tls_version
  infrastructure_encryption_enabled = var.infrastructure_encryption_enabled
  tags                      		= var.tags

  lifecycle {
    ignore_changes = [
      infrastructure_encryption_enabled
    ]
  }
}