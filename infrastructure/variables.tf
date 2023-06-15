#  network module variables
#  for VPC

variable "loop" {
  description = "a counting variable for dynamic customaisation"
  type        = number
  default     = 3

}

variable "aws_region" {
  description = "the required AWS region"
  type        = string
  default     = "eu-west-2"
}

variable "vpc_name" {
  description = "the name for the VPC"
  type        = string
  default     = "unnamed_vpc"
}

variable "vpc_cidr_suf" {
  description = "required CIDR suffix for VPC"
  type        = string
  default     = "16"
}

variable "sn_cidr_suf" {
  description = "required CIDR suffix for subnets"
  type        = string
  default     = "24"
}

variable "enable_nat_gateway" {
  description = "boolean value whether or not to enable NAT gateway"
  type        = bool
  default     = true
}

variable "enable_vpn_gateway" {
  description = "boolean value whether or not to enable VPN gateway"
  type        = bool
  default     = true
}