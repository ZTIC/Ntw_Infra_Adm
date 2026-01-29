# Resource Group
module "resource_group" {
  source = "./modules/resource_group"

  prefix      = var.project_name
  environment = var.environment
  location    = var.location
  tags        = var.tags
}

# Event Hub para streaming de pedidos
module "event_hub" {
  source = "./modules/event_hub"

  prefix              = var.project_name
  environment         = var.environment
  location            = var.location
  resource_group_name = module.resource_group.resource_group_name
  tags                = var.tags
}

# Storage Account para arquivamento (10 anos)
module "storage" {
  source = "./modules/storage"

  prefix              = var.project_name
  environment         = var.environment
  location            = var.location
  resource_group_name = module.resource_group.resource_group_name
  tags                = var.tags
  retention_days      = 3650 # 10 anos
}