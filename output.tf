data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_partition" "current" {}

output "region" {
  value = data.aws_region.current
}

output "web-alb-dns" {
  value = aws_lb.alb-web.dns_name
}

output "rds-endpoint" {
  value = data.aws_db_instance.my_rds.endpoint
}
