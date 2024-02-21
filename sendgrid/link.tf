module "const" {
  source = "../const"
}

locals {
  origin_id = "sendgrid"
}

module "certificate" {
  source = "../certificate"
  zone_id = var.zone_id
  domain = var.domain
  subdomains = var.link_tracking_subdomains
  tags = module.this.tags
}

resource "aws_cloudfront_distribution" "main" {
  enabled = true
  is_ipv6_enabled = true
  price_class = var.price_class
  http_version = "http2"
  aliases = formatlist(
    "%s.${var.domain}",
    var.link_tracking_subdomains
  )

  viewer_certificate {
    ssl_support_method = "sni-only"
    acm_certificate_arn = module.certificate.arn
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  default_cache_behavior {
    target_origin_id = local.origin_id
    viewer_protocol_policy = "redirect-to-https"
    compress = true
    smooth_streaming = false

    allowed_methods = [
      "HEAD",
      "GET"
    ]

    cached_methods = [
      "HEAD",
      "GET"
    ]

    forwarded_values {
      query_string = true
      headers = [
        "Host"
      ]
      cookies {
        forward = "none"
      }
    }
  }

  origin {
    origin_id = local.origin_id
    domain_name = var.sendgrid_tracking_domain

    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols = [
        "TLSv1.2"
      ]
    }
  }

  tags = module.this.tags
}

resource "aws_route53_record" "link" {
  for_each = toset(var.link_tracking_subdomains)
  name = "${each.key}.${var.domain}"
  type = "CNAME"
  zone_id = var.zone_id
  ttl = var.ttl
  records = [aws_cloudfront_distribution.main.domain_name]
}
