# EKS Module
variable "cluster_version" {
  type        = string
  description = "EKS cluster version"
  default     = "1.28"
}

output "cluster_name" {
  value = "TODO: implement EKS module"
}
