resource "aws_acm_certificate" "main" {
  provider          = "aws.us-east-1"
  domain_name       = "${local.domain}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_zone" "wedat_info" {
  # imported: id = Z21RFSJQHJYIR9
  name = "wedat.info."
}

resource "aws_route53_record" "main" {
  zone_id = "${aws_route53_zone.wedat_info.zone_id}"
  name    = "${local.domain}"
  type    = "A"

  alias {
    name                   = "${aws_cloudfront_distribution.main.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.main.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "main_acm_validation" {
  count   = "${length(aws_acm_certificate.main.domain_validation_options)}"
  zone_id = "${aws_route53_zone.wedat_info.zone_id}"
  name    = "${lookup(aws_acm_certificate.main.domain_validation_options[count.index],"resource_record_name")}"
  type    = "${lookup(aws_acm_certificate.main.domain_validation_options[count.index],"resource_record_type")}"
  ttl     = "300"
  records = ["${lookup(aws_acm_certificate.main.domain_validation_options[count.index],"resource_record_value")}"]
}
