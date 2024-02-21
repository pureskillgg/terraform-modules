terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    sentry = {
      source = "jianyuan/sentry"
    }
  }
  required_version = "~> 1.0"
}
