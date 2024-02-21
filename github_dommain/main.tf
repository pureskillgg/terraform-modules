locals {
  github_pages_domain = "${var.organization}.github.io"
  github_prefix = "_github-challenge-${var.organization}"
  github_pages_prefix = "_github-pages-challenge-${var.organization}"
}

resource "aws_route53_record" "main" {
  name = "${local.github_prefix}.${var.domain}."
  type = "TXT"
  ttl = var.ttl
  zone_id = var.zone_id
  records = [
    var.verification_code
  ]
}

resource "aws_route53_record" "pages" {
  name = "${local.github_pages_prefix}.${var.domain}."
  type = "TXT"
  ttl = var.ttl
  zone_id = var.zone_id
  records = [
    var.pages_verification_code
  ]
}

resource "aws_route53_record" "subdomain" {
  for_each = toset(var.pages_subdomains)
  name = "${each.key}.${var.domain}"
  type = "CNAME"
  ttl = var.ttl
  zone_id = var.zone_id
  records = [local.github_pages_domain]
}
