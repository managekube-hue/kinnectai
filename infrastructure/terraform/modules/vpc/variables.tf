# VPC Module
variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
  default     = "10.0.0.0/16"
}

output "vpc_id" {
  value = "TODO: implement VPC module"
}
