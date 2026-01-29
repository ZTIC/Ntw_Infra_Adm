output "storage_account_name" {
  description = "Storage account name"
  value       = azurerm_storage_account.this.name
}

output "storage_account_primary_key" {
  description = "Storage account primary access key"
  value       = azurerm_storage_account.this.primary_access_key
  sensitive   = true
}

output "storage_account_connection_string" {
  description = "Storage account connection string"
  value       = azurerm_storage_account.this.primary_connection_string
  sensitive   = true
}

output "container_name" {
  description = "Container name"
  value       = azurerm_storage_container.orders.name
}