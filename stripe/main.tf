locals {
  stripe_domain = "stripe.com"
  stripe_email_domain = "custom-email-domain.${local.stripe_domain}"

  dkim_local_domain = "_domainkey.${var.domain}"
  dkim_remote_domain = "dkim.${local.stripe_email_domain}"

  cname_records = {
    "${var.dkim[0]}.${local.dkim_local_domain}" = "${var.dkim[0]}.${local.dkim_remote_domain}"
    "${var.dkim[1]}.${local.dkim_local_domain}" = "${var.dkim[1]}.${local.dkim_remote_domain}"
    "${var.dkim[2]}.${local.dkim_local_domain}" = "${var.dkim[2]}.${local.dkim_remote_domain}"
    "${var.dkim[3]}.${local.dkim_local_domain}" = "${var.dkim[3]}.${local.dkim_remote_domain}"
    "${var.dkim[4]}.${local.dkim_local_domain}" = "${var.dkim[4]}.${local.dkim_remote_domain}"
    "${var.dkim[5]}.${local.dkim_local_domain}" = "${var.dkim[5]}.${local.dkim_remote_domain}"
  }
  cname_keys = keys(local.cname_records)
}

resource "aws_route53_record" "verification" {
  name = var.domain
  type = "TXT"
  ttl = var.ttl
  zone_id = var.zone_id
  records = ["stripe-verification=${var.verification_code}"]
}

resource "aws_route53_record" "cname" {
  for_each = local.cname_records
  name = each.key
  type = "CNAME"
  ttl = var.ttl
  zone_id = var.zone_id
  records = [each.value]
}

resource "aws_route53_record" "bounce" {
  name = "bounce.${var.domain}"
  type = "CNAME"
  ttl = var.ttl
  zone_id = var.zone_id
  records = [local.stripe_email_domain]
}
