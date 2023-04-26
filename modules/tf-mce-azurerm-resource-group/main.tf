/**
  * ## Descriptions
  * 
  * Terraform module for the creation of a Resource Group.
  *
  */

resource "azurerm_resource_group" "resource_group" {
  name     = var.name
  location = var.location
  tags     = var.tags
}
