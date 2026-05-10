# Schema Registry Module
variable "kafka_bootstrap_brokers" {
  type        = list(string)
  description = "Kafka bootstrap brokers"
}

output "schema_registry_url" {
  value = "TODO: implement Schema Registry module"
}
