# C2PA Signing Module
variable "kms_key_algorithm" {
  type        = string
  description = "KMS key algorithm"
  default     = "ECC_NIST_P256"
}

output "kms_key_id" {
  value = "TODO: implement C2PA module"
}
