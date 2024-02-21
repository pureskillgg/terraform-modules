module "this" {
  source = "../scope"
  id = var.id
  name = var.name
  meta = var.meta
  tags = var.tags
}

module "const" {
  source = "../const"
}

locals {
  origin_id = module.this.name
}

resource "aws_cloudfront_origin_access_identity" "main" {
  comment = local.origin_id
}

resource "aws_cloudfront_distribution" "main" {
  enabled = true
  is_ipv6_enabled = true
  price_class = var.price_class
  http_version = "http2"
  default_root_object = var.default_root_object

  aliases = [
    var.domain
  ]

  viewer_certificate {
    ssl_support_method = "sni-only"
    acm_certificate_arn = var.certificate_arn
  }

  origin {
    origin_id = local.origin_id
    domain_name = var.bucket.regional_domain_name

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.main.cloudfront_access_identity_path
    }
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

    min_ttl = var.min_ttl
    default_ttl = var.default_ttl
    max_ttl = var.min_ttl

    allowed_methods = [
      "DELETE",
      "GET",
      "HEAD",
      "OPTIONS",
      "PATCH",
      "POST",
      "PUT"
    ]

    cached_methods = [
      "GET",
      "HEAD",
      "OPTIONS"
    ]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
      headers = [
        "Authorization",
        "Access-Control-Request-Method",
        "Access-Control-Request-Headers",
        "Origin",
        "X-Forwarded-Host"
      ]
    }
  }

  tags = module.this.tags

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_route53_record" "main" {
  name = var.domain
  type = "A"
  zone_id = var.zone_id

  alias {
    name = aws_cloudfront_distribution.main.domain_name
    zone_id = module.const.cloudfront_zone_id
    evaluate_target_health = true
  }
}

data "aws_iam_policy_document" "main" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject"
    ]

    resources = formatlist("${var.bucket.arn}/%s", var.allowed_resources)

    principals {
      type = "AWS"
      identifiers = [
        aws_cloudfront_origin_access_identity.main.iam_arn
      ]
    }
  }

  statement {
    effect = "Deny"

    actions = [
      "s3:ListBucket",
    ]

    resources = [
      var.bucket.arn
    ]

    principals {
      type = "AWS"
      identifiers = [
        aws_cloudfront_origin_access_identity.main.iam_arn
      ]
    }
  }
}

resource "aws_s3_bucket_policy" "main" {
  bucket = var.bucket.id
  policy = data.aws_iam_policy_document.main.json
}
