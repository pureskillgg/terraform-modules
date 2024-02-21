module "this" {
  source = "../scope"
  name = var.name
  id = var.id
  meta = var.meta
  tags = var.tags
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws" # external_source
  version = "3.14.1"
  name = module.this.name

  azs = var.azs
  cidr = var.cidr
  private_subnets = var.private_subnets
  public_subnets = var.public_subnets

  enable_dns_hostnames = true
  enable_nat_gateway = var.use_ec2_nat ? false : true
  single_nat_gateway = true
  one_nat_gateway_per_az = false

  tags = module.this.tags
}
