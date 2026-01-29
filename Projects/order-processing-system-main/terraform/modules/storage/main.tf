# Adicione o provider random_string no início do arquivo
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "azurerm_storage_container" "orders" {
  name                  = "orders-archive"
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"
}

resource "azurerm_storage_account" "this" {
  name                     = "${replace(var.prefix, "-", "")}${var.environment}${random_string.suffix.result}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  
  min_tls_version          = "TLS1_2"
  https_traffic_only_enabled = true  # Atualizado!
  
  blob_properties {
    versioning_enabled = true
  }
  
  tags = var.tags
}

resource "azurerm_storage_management_policy" "this" {
  storage_account_id = azurerm_storage_account.this.id

  rule {
    name    = "archiveOldBlobs"
    enabled = true
    
    filters {
      prefix_match = ["orders/"]
      blob_types   = ["blockBlob"]
    }
    
    actions {
      base_blob {
        tier_to_cool_after_days_since_modification_greater_than    = 30
        tier_to_archive_after_days_since_modification_greater_than = 90
        delete_after_days_since_modification_greater_than          = var.retention_days
      }
    }
  }
}