resource "azurerm_resource_group" "this" {
  name     = "${var.prefix}-rg-${var.environment}"
  location = var.location
  
  tags = var.tags
}