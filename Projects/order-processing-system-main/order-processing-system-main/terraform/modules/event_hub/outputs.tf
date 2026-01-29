output "namespace_name" {
  description = "Event Hub Namespace name"
  value       = azurerm_eventhub_namespace.this.name
}

output "eventhub_name" {
  description = "Event Hub name"
  value       = azurerm_eventhub.orders.name
}

output "send_connection_string" {
  description = "Send connection string"
  value       = azurerm_eventhub_authorization_rule.send.primary_connection_string
  sensitive   = true
}

output "listen_connection_string" {
  description = "Listen connection string"
  value       = azurerm_eventhub_authorization_rule.listen.primary_connection_string
  sensitive   = true
}