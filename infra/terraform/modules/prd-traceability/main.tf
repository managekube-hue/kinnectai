terraform {
  required_version = ">= 1.6.0"
}

variable "table_name" {
  description = "PRD traceability table name"
  type        = string
  default     = "prd_traceability"
}

variable "database_url" {
  description = "Postgres connection URL used by the traceability gate"
  type        = string
  sensitive   = true
}

output "traceability_table" {
  value       = var.table_name
  description = "Table storing PRD-to-code/test linkage"
}

output "database_url_configured" {
  value       = var.database_url != ""
  description = "Whether database URL has been provided"
}
