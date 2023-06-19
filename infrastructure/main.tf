module "network" {
  source = "./modules/network"

  aws_region           = var.aws_region
  vpc_name             = var.vpc_name
}

module "eks_cluster" {
    source          = "./modules/containerisation"

    vpc_id          = module.network.vpc_id
    private_subnets = module.network.private_subnets
    cluster_name    = var.cluster_name
}