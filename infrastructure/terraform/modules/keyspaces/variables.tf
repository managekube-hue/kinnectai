# Cassandra (Keyspaces) Module
variable "replication_factor" {
  type        = number
  description = "Replication factor"
  default     = 3
}

output "keyspace_arn" {
  value = "TODO: implement Keyspaces module"
}
