module "this" {
  source = "../scope"
  name = var.name
  id = var.id
  meta = var.meta
  tags = var.tags
}

module "certificate" {
  source = "../../lib/certificate"
  zone_id = var.zone_id
  domain = var.domain
  tags = module.this.tags
}

resource "aws_cognito_user_pool" "main" {
  name = module.this.name
  tags = module.this.tags

  username_configuration {
    case_sensitive = false
  }

  auto_verified_attributes = [
    "email"
  ]

  alias_attributes = [
    "email"
  ]

  admin_create_user_config {
    allow_admin_create_user_only = false
  }

  account_recovery_setting {
    recovery_mechanism {
      name = "verified_email"
      priority = 1
    }
  }

  email_configuration {
    source_arn = var.ses_email_identity_arn
    from_email_address = var.from_email
    reply_to_email_address = var.reply_to_email
    email_sending_account = "DEVELOPER"
  }

  password_policy  {
    minimum_length = 8
    require_lowercase = false
    require_numbers = false
    require_symbols = false
    require_uppercase = false
    temporary_password_validity_days = 7
  }

  schema {
    name = "env"
    required = false
    attribute_data_type = "String"
    developer_only_attribute = false
    mutable = false
    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }

  schema {
    name = "origin"
    required = false
    attribute_data_type = "String"
    developer_only_attribute = false
    mutable = false
    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }

  schema {
    name = "marketing_signup"
    required = false
    attribute_data_type = "Boolean"
    developer_only_attribute = false
    mutable = false
  }

  schema {
    name = "affiliate"
    required = false
    attribute_data_type = "String"
    developer_only_attribute = false
    mutable = false
    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }

  schema {
    name = "retro_affiliate"
    required = false
    attribute_data_type = "String"
    developer_only_attribute = false
    mutable = true
    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }

  schema {
    name = "referrer"
    required = false
    attribute_data_type = "String"
    developer_only_attribute = false
    mutable = false
    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }

  lifecycle {
    prevent_destroy = true

    ignore_changes = [
      lambda_config
    ]
  }
}
