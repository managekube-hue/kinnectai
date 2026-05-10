# RDS Aurora PostgreSQL Module
variable "db_name" {
  type        = string
  description = "Database name"
  default     = "kinnectai"
}

variable "master_username" {
  type        = string
  description = "Master username"
  sensitive   = true
}

variable "master_password" {
  type        = string
  description = "Master password"
  sensitive   = true
}

output "endpoint" {
  value = "TODO: implement RDS module"
}
