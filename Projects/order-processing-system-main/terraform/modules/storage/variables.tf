variable "prefix" {
  description = "Prefixo para nomes de recursos"
  type        = string
}

variable "environment" {
  description = "Ambiente (dev, staging, prod)"
  type        = string
}

variable "location" {
  description = "Localização do Azure"
  type        = string
}

variable "resource_group_name" {
  description = "Nome do Resource Group"
  type        = string
}

variable "retention_days" {
  description = "Dias de retenção para auditoria"
  type        = number
  default     = 3650  # 10 anos
}

variable "tags" {
  description = "Tags para os recursos"
  type        = map(string)
  default     = {}
}