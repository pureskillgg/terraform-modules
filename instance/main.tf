module "this" {
  source = "../scope"
  id = var.id
  name = var.name
  meta = var.meta
  tags = var.tags
}

resource "aws_instance" "main" {
  count = var.instance_count
  ami = var.ami
  instance_type = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.main.name
  key_name = var.key_name
  subnet_id = var.subnet_id
  vpc_security_group_ids = var.security_groups
  user_data = var.user_data
  source_dest_check = var.source_dest_check
  root_block_device {
    encrypted = true
    delete_on_termination = true
    volume_size = var.volume_size
    volume_type = "gp3"
  }
  tags = merge(
    module.this.ec2_tags,
    {
      "Name" = "${count.index}-${module.this.ec2_tags.Name}"
    }
  )
}

resource "aws_iam_policy" "main" {
  policy = var.policy
  path = module.this.iam_path
  name_prefix = module.this.name_prefix
}

resource "aws_iam_role_policy_attachment" "main" {
  role = aws_iam_role.main.name
  policy_arn = aws_iam_policy.main.arn
}

resource "aws_iam_role" "main" {
  name_prefix = module.this.name_prefix
  path = module.this.iam_path
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
  tags = module.this.tags
}

resource "aws_iam_instance_profile" "main" {
  name = module.this.name
  path = module.this.iam_path
  role = aws_iam_role.main.name
}

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com"
      ]
    }
  }
}
