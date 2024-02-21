locals {
  mail_from_mx_record = join(".", [
    "feedback-smtp",
    data.aws_region.main.name,
    local.amazonses_domain
  ])
}

resource "aws_ses_domain_mail_from" "main" {
  domain = aws_ses_domain_identity.main.domain
  mail_from_domain = join(".", [
    var.mail_from_subdomain,
    aws_ses_domain_identity.main.domain
  ])
}

locals {
  mail_from_domain = aws_ses_domain_mail_from.main.mail_from_domain
}

resource "aws_route53_record" "mail_from_mx" {
  name = local.mail_from_domain
  type = "MX"
  ttl = var.ttl
  zone_id = var.zone_id
  records = [
    join(" ", [var.mx_priority, local.mail_from_mx_record])
  ]
}

resource "aws_route53_record" "mail_from_spf" {
  name = local.mail_from_domain
  type = "TXT"
  ttl = var.ttl
  zone_id = var.zone_id
  records = [
    var.spf
  ]
}

resource "aws_route53_record" "dmarc" {
  name = "_dmarc.${local.mail_from_domain}"
  type = "TXT"
  ttl = var.ttl
  zone_id = var.zone_id
  records = [
    "v=DMARC1; p=none; rua=mailto:postmaster@${local.root_domain}"
  ]
}
