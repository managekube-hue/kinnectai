# ElastiCache Redis Module
variable "node_type" {
  type        = string
  description = "Redis node type"
  default     = "cache.r6g.xlarge"
}

variable "num_cache_clusters" {
  type        = number
  description = "Number of cache clusters"
  default     = 2
}

output "endpoint" {
  value = "TODO: implement ElastiCache module"
}
