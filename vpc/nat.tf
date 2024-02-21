module "nat" {
  source = "../instance"
  id = var.id
  name = "${var.name}-nat"
  ami = local.nat_amis[var.region]
  instance_count = var.use_ec2_nat ? 1 : 0
  instance_type = var.nat_instance_type
  key_name = null
  subnet_id = module.vpc.public_subnets[0]
  source_dest_check = false
  security_groups = [
    aws_security_group.nat.id
  ]
  volume_size = 8
  policy = data.aws_iam_policy_document.nat.json
  meta = var.meta
  tags = var.tags
}

resource "aws_eip" "nat" {
  count = var.use_ec2_nat ? 1 : 0
  instance = module.nat.ids[0]
  vpc = true
}

resource "aws_route" "nat" {
  count = var.use_ec2_nat ? length(local.private_route_table_ids) : 0
  route_table_id = local.private_route_table_ids[count.index]
  network_interface_id = module.nat.network_interface_ids[0]
  destination_cidr_block = "0.0.0.0/0"
}

locals {
  private_route_table_ids = module.vpc.private_route_table_ids
  nat_amis = {
    "us-east-1" = "ami-0780b09c119334593"
  }
}

data "aws_iam_policy_document" "nat" {
  statement {
    effect = "Deny"
    actions = ["*"]
    resources = ["*"]
  }
}

resource "aws_security_group" "nat" {
  name = "${module.this.name}-nat"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}
