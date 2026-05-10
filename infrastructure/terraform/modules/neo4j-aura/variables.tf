# Neo4j Aura Module
variable "instance_type" {
  type        = string
  description = "Neo4j instance type"
  default     = "enterprise-db-m5"
}

output "connection_uri" {
  value = "TODO: implement Neo4j module"
}
