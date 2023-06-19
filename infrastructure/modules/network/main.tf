# Local variables

locals {
  azs             = [for i in range(var.loop) : "${var.aws_region}${element(["a", "b", "c"], i)}"]
  private_subnets = [for i in range(var.loop) : "10.0.${i + 1}.0/${var.sn_cidr_suf}"]
  public_subnets  = [for i in range(var.loop) : "10.0.10${i + 1}.0/${var.sn_cidr_suf}"]
}

# Refactored VPC module

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = "10.0.0.0/${var.vpc_cidr_suf}"

  azs             = local.azs
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets

  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = var.enable_nat_gateway
  enable_vpn_gateway = var.enable_vpn_gateway

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
  }
  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}