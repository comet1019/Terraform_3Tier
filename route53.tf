# ACM 인증서 생성
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}
resource "aws_acm_certificate" "cert" {
  provider = aws.us_east_1
  domain_name       = "mkcloud.site"
  subject_alternative_names = ["mkcloud.site", "web.mkcloud.site"]
  validation_method = "DNS"

   lifecycle {
    create_before_destroy = true
  }

   tags = {
    Name = "mkcloud.site-ACM"
    Owner = var.owner-tag
  }
}

# ACM 검증
resource "aws_acm_certificate_validation" "cert" {
  provider = aws.us_east_1
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
  depends_on = [aws_route53_record.cert_validation]

}


# ACM 검증을 위한 CNAME 레코드 생성
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.zone.zone_id


}

resource "aws_route53_record" "web" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "web.${var.domain-name}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cdn-web-elb-distribution.domain_name
    zone_id                = aws_cloudfront_distribution.cdn-web-elb-distribution.hosted_zone_id
    evaluate_target_health = false
  }
}
/*
resource "aws_route53_record" "apex" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = var.domain-name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cdn-web-elb-distribution.domain_name
    zone_id                = aws_cloudfront_distribution.cdn-web-elb-distribution.hosted_zone_id
    evaluate_target_health = false
  }
}
*/
data "aws_route53_zone" "zone" {
  name         = "mkcloud.site"
  private_zone = false
}



/*

# ALB에 사용되는 ACM 인증서 (싱가포르 리전)
resource "aws_acm_certificate" "alb-cert" {
  domain_name       = "web.mkcloud.site"
  validation_method = "DNS"
  
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "mkcloud.site-ACM"
    Owner = var.owner-tag
  }
}

# ACM 검증
resource "aws_acm_certificate_validation" "alb-cert" {
  certificate_arn         = aws_acm_certificate.alb-cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
  depends_on = [aws_route53_record.alb-cert_validation]

}


# ACM 검증을 위한 CNAME 레코드 생성
resource "aws_route53_record" "alb-cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.zone.zone_id

}

resource "aws_route53_record" "alb-web" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "web.${var.domain-name}"
  type    = "A"
  ttl     = 86400
  records = [aws_lb.alb-web.dns_name]
}
*/