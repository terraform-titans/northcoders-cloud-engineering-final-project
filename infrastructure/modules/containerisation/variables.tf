variable "cluster_name" {
  description = "the name of the EKS cluster"
  type        = string
  default     = "unnamed_cluster"
}

variable "vpc_id" {
  description = "the ID of the provisioned VPC"
  type        = string
}

variable "private_subnets" {
  description = "the IDs of the provisioned private subnets"
  type        = list(string)
}