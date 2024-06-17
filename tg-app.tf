resource "aws_lb_target_group" "target-group-app" {
  name     = var.tg-app-name
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
  health_check {
    path    = "/"
    matcher = "200-299"
    interval = 5
    timeout = 3
    healthy_threshold = 3
    unhealthy_threshold = 5

  }

  tags = {
    Name = var.tg-app-name
    Owner = var.owner-tag
  }
}

resource "aws_lb_listener" "alb_listener-app" {
  load_balancer_arn = aws_lb.alb-app.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group-app.arn
  }

  depends_on = [aws_lb.alb-app]

  tags = {
    Owner = var.owner-tag
  }
}

resource "aws_lb_target_group" "target-group-app-bluegreen" {
  name     = "blue-green-app"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  stickiness {
    type         = "lb_cookie"  # 스티키 세션의 유형을 지정합니다. "lb_cookie" 또는 "app_cookie" 중 하나를 선택할 수 있습니다.
    cookie_duration = 3600       # 스티키 세션의 지속 시간을 설정합니다. (초 단위)
  }

  health_check {
    path    = "/"
    matcher = "200-299"
    interval = 5
    timeout = 3
    healthy_threshold = 3
    unhealthy_threshold = 5

  }

  depends_on = [aws_lb.alb-app]

  tags = {
    Name = "blue-green-app"
    Owner = var.owner-tag
  }
}

resource "aws_lb_listener" "bluegreen-alb-listener-app" {
  load_balancer_arn = aws_lb.alb-app.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group-app-bluegreen.arn
  }

  depends_on = [aws_acm_certificate_validation.cert]
}