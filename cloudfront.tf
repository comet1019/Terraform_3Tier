resource "aws_cloudfront_distribution" "cdn-web-elb-distribution" {
  origin {
    domain_name = aws_lb.alb-web.dns_name
    origin_id   = "my-web-alb"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }

  }

  aliases         = [var.domain-name, "web.${var.domain-name}"]


  enabled         = true
  is_ipv6_enabled = true
  comment         = "CDN ALB Distribution"
  price_class     = "PriceClass_100"

  

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "my-web-alb"

    forwarded_values {
      query_string = false
      headers      = ["*"]
      cookies {
        forward = "all"
      }

    }

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400

    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "blacklist"
      locations        = ["CA"]
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
  
  

  #web_acl_id = aws_wafv2_web_acl.web_acl.arn

  tags = {
    Owner = var.owner-tag
    Name = "lhs-cdn"
  }

  depends_on = [aws_acm_certificate_validation.cert]
}