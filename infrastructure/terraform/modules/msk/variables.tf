# MSK (Managed Streaming for Kafka) Module
variable "broker_count" {
  type        = number
  description = "Number of brokers"
  default     = 3
}

variable "instance_type" {
  type        = string
  description = "Broker instance type"
  default     = "kafka.m5.xlarge"
}

output "bootstrap_brokers" {
  value = "TODO: implement MSK module"
}
