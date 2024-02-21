module "this" {
  source = "../scope"
  id = var.id
  name = var.name
  meta = var.meta
  tags = var.tags
}

locals {
  mailgun_domain = "mailgun.org"
  mailgun_mx_records = [
    "mxa",
    "mxb"
  ]
}

resource "aws_route53_record" "dkim" {
  name = "${var.dkim_prefix}._domainkey.${var.domain}"
  type = "TXT"
  ttl = var.ttl
  zone_id = var.zone_id
  records = [
    replace(var.dkim, " ", "\"\"")
  ]
}

resource "aws_route53_record" "mx" {
  name = var.domain
  type = "MX"
  ttl = var.ttl
  zone_id = var.zone_id
  records = formatlist(
    "${var.mx_priority} %s.${local.mailgun_domain}",
    local.mailgun_mx_records
  )
}

resource "aws_route53_record" "spf" {
  count = var.create_spf ? 1 : 0
  name = var.domain
  type = "TXT"
  ttl = var.ttl
  zone_id = var.zone_id
  records = [
    var.spf
  ]
}
