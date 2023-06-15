module "network" {
  source = "./modules/network"

  aws_region           = var.aws_region
  vpc_name             = var.vpc_name
  launch_template_name = var.launch_template_name
  security_group_name  = var.security_group_name
  load_balancer_name   = var.load_balancer_name
}