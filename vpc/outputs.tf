output "name" {
  value = module.this.name
}

output "id" {
  value = module.vpc.vpc_id
}

output "region" {
  value = var.region
}

output "cidr_block" {
  value = module.vpc.vpc_cidr_block
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "nat_public_ips" {
  value = module.vpc.nat_public_ips
}

output "azs" {
  value = module.vpc.azs
}

output "default_security_group_id" {
  value = module.vpc.default_security_group_id
}

output "security_group_egress_id" {
  value = aws_security_group.egress.id
}

output "security_group_ssh_id" {
  value = aws_security_group.ssh.id
}
