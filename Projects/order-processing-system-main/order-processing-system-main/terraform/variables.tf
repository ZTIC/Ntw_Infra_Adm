variable "environment" {
  description = "Nome do ambiente (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Região do Azure"
  type        = string
  default     = "eastus"
}

variable "project_name" {
  description = "Nome do projeto"
  type        = string
  default     = "oms"
}

variable "company_name" {
  description = "Nome da empresa"
  type        = string
  default     = "mygreatcompany"
}

variable "tags" {
  description = "Tags para todos os recursos"
  type        = map(string)
  default = {
    Environment = "dev"
    Project     = "OrderManagementSystem"
    ManagedBy   = "Terraform"
  }
}