/**
  * ## Descriptions
  * 
  * Terraform module for the creation of a App Service Plan
  *
  */


resource "azurerm_app_service_plan" "app_service_plan" {
  name                         = var.app_service_plan_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  kind                         = var.kind
  maximum_elastic_worker_count = var.maximum_elastic_worker_count
  app_service_environment_id   = var.app_service_environment_id
  reserved                     = var.reserved
  per_site_scaling             = var.per_site_scaling
  zone_redundant               = var.zone_redundant
  tags                         = var.tags

  sku {
    tier     = var.sku.tier
    size     = var.sku.size
    capacity = var.sku.capacity
  }
}