resource "aws_cloudfront_origin_access_control" "this" {
  name                              = "oac-${var.aliases[0]}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_function" "redirect_www" {
  count   = var.enable_redirect_www ? 1 : 0
  name    = "redirect-www"
  runtime = "cloudfront-js-1.0"
  publish = true
  code    = file("${path.module}/redirect.js")
}

resource "aws_cloudfront_distribution" "this" {
  enabled = true
  comment = "Static site"

  origin {
    domain_name              = var.bucket_regional_domain_name
    origin_id                = "s3-origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.this.id
  }

  default_root_object = "index.html"

  aliases = var.aliases

  default_cache_behavior {
    target_origin_id       = "s3-origin"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]

    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    # AWS Managed: CachingOptimized
  }

  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

