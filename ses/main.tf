data "aws_region" "main" {}

data "aws_route53_zone" "main" {
  zone_id = var.zone_id
}

locals {
  amazonses_domain = "amazonses.com"
  root_domain = trimsuffix(data.aws_route53_zone.main.name, ".")
  noreply = "${var.noreply}@${var.domain}"
}

resource "aws_ses_domain_identity" "main" {
  domain = var.domain
}

resource "aws_ses_domain_identity_verification" "main" {
  domain = aws_ses_domain_identity.main.id
  depends_on = [aws_route53_record.main]
}

resource "aws_route53_record" "main" {
  name = "_amazonses.${aws_ses_domain_identity.main.domain}"
  type = "TXT"
  ttl = var.ttl
  zone_id = var.zone_id
  records = [
    aws_ses_domain_identity.main.verification_token
  ]
}

resource "aws_route53_record" "spf" {
  count = var.create_spf ? 1 : 0
  name = aws_ses_domain_identity.main.domain
  type = "TXT"
  ttl = var.ttl
  zone_id = var.zone_id
  records = [
    var.spf
  ]
}

resource "aws_ses_email_identity" "noreply" {
  email = local.noreply
}

data "aws_iam_policy_document" "main" {
  statement {
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = [
        "cognito-idp.amazonaws.com"
      ]
    }

    actions = [
      "ses:SendEmail",
      "ses:SendRawEmail"
    ]

    resources = [
      aws_ses_domain_identity.main.arn
    ]
  }
}

resource "aws_ses_identity_policy" "main" {
  name = "ses-${var.zone_id}"
  identity = aws_ses_domain_identity.main.arn
  policy = data.aws_iam_policy_document.main.json
}

data "aws_iam_policy_document" "noreply" {
  statement {
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = [
        "cognito-idp.amazonaws.com"
      ]
    }

    actions = [
      "ses:SendEmail",
      "ses:SendRawEmail"
    ]

    resources = [
      aws_ses_email_identity.noreply.arn
    ]
  }
}

resource "aws_ses_identity_policy" "noreply" {
  name = "ses-${var.zone_id}-noreply"
  identity = aws_ses_email_identity.noreply.arn
  policy = data.aws_iam_policy_document.noreply.json
}
