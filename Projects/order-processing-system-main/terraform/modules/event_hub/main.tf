resource "azurerm_eventhub_namespace" "this" {
  name                = "${var.prefix}-eventhub-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  capacity            = 1
  
  tags = var.tags
}

resource "azurerm_eventhub" "orders" {
  name                = "orders"
  namespace_name      = azurerm_eventhub_namespace.this.name
  resource_group_name = var.resource_group_name
  partition_count     = 2
  message_retention   = 7
}

# Authorization rules
resource "azurerm_eventhub_authorization_rule" "send" {
  name                = "send-policy"
  namespace_name      = azurerm_eventhub_namespace.this.name
  eventhub_name       = azurerm_eventhub.orders.name
  resource_group_name = var.resource_group_name
  listen              = false
  send                = true
  manage              = false
}

resource "azurerm_eventhub_authorization_rule" "listen" {
  name                = "listen-policy"
  namespace_name      = azurerm_eventhub_namespace.this.name
  eventhub_name       = azurerm_eventhub.orders.name
  resource_group_name = var.resource_group_name
  listen              = true
  send                = false
  manage              = false
}