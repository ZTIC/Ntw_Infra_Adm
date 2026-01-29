output "resource_group_name" {
  description = "Nome do Resource Group"
  value       = module.resource_group.resource_group_name
}

output "eventhub_namespace" {
  description = "Nome do Event Hub Namespace"
  value       = module.event_hub.namespace_name
}

output "eventhub_name" {
  description = "Nome do Event Hub"
  value       = module.event_hub.eventhub_name
}

output "storage_account_name" {
  description = "Nome da Storage Account"
  value       = module.storage.storage_account_name
}

output "eventhub_send_connection_string" {
  description = "Connection string para envio ao Event Hub"
  value       = module.event_hub.send_connection_string
  sensitive   = true
}

output "eventhub_listen_connection_string" {
  description = "Connection string para consumo do Event Hub"
  value       = module.event_hub.listen_connection_string
  sensitive   = true
}

output "storage_account_key" {
  description = "Chave da Storage Account"
  value       = module.storage.storage_account_primary_key
  sensitive   = true
}

output "storage_container_name" {
  description = "Nome do container de storage"
  value       = module.storage.container_name
}

output "summary" {
  description = "Resumo dos recursos criados"
  value = {
    resource_group  = module.resource_group.resource_group_name
    eventhub        = module.event_hub.namespace_name
    storage_account = module.storage.storage_account_name
    container       = module.storage.container_name
    location        = var.location
  }
}

output "sensitive_connection_strings" {
  description = "Strings de conexão sensíveis"
  value = {
    eventhub_send   = module.event_hub.send_connection_string
    eventhub_listen = module.event_hub.listen_connection_string
    storage_account = module.storage.storage_account_connection_string
  }
  sensitive = true
}