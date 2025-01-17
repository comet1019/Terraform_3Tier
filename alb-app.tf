resource "aws_lb" "alb-app" {
  name               = var.alb-app-name
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-security-group-app.id]
  subnets            = [aws_subnet.app-subnet1.id, aws_subnet.app-subnet2.id]

  tags = {
    Name = var.alb-app-name
    Owner = var.owner-tag
  }
}