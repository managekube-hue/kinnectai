# CloudHSM Module
variable "hsm_count" {
  type        = number
  description = "Number of HSMs"
  default     = 3
}

output "cluster_id" {
  value = "TODO: implement CloudHSM module"
}
