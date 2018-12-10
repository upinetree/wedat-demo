resource "aws_cloudfront_distribution" "main" {
  enabled = true

  origin = {
    domain_name = "${aws_s3_bucket.assets.id}.s3.amazonaws.com"
    origin_id   = "${local.s3_origin_id}"
  }

  aliases = ["${local.domain}"]

  default_cache_behavior = {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "${local.s3_origin_id}"
    viewer_protocol_policy = "https-only"

    forwarded_values {
      cookies {
        forward = "none"
      }

      query_string = false
    }

    compress = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = "${aws_acm_certificate.main.arn}"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.1_2016"
  }

  default_root_object = "index.html"

  custom_error_response {
    error_code            = "400"
    error_caching_min_ttl = 0
  }

  custom_error_response {
    error_code            = "403"
    error_caching_min_ttl = 0
  }

  custom_error_response {
    error_code            = "404"
    error_caching_min_ttl = 0
    response_page_path    = "/index.html"
    response_code         = "200"
  }

  is_ipv6_enabled = true
}
