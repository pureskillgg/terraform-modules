resource "aws_ses_domain_dkim" "main" {
  domain = aws_ses_domain_identity.main.domain
}

resource "aws_route53_record" "dkim" {
  for_each = toset(aws_ses_domain_dkim.main.dkim_tokens)

  name = join(".", [
    each.key,
    "_domainkey",
    var.domain
  ])

  records = [
    join(".", [
      each.key,
      "dkim",
      local.amazonses_domain
    ])
  ]

  type = "CNAME"
  ttl = var.ttl
  zone_id = var.zone_id
}
