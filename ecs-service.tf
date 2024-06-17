## web
resource "aws_ecs_service" "web-ecs-service" {
  name            = "${var.web-prefix}-${var.ecs-service-name}"
  cluster         = aws_ecs_cluster.ecs-cluster-web.id
  task_definition = aws_ecs_task_definition.web-ecs-service.arn
  desired_count   = 4


  depends_on = [aws_ecs_task_definition.web-ecs-service,aws_ecs_cluster.ecs-cluster-web]
  
  deployment_controller {
    type = "CODE_DEPLOY"
  }


  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }
  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.target-group-web.arn
    container_name   = "web-nginx-container"
    container_port   = 80
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone == ${var.az-1} || attribute:ecs.availability-zone == ${var.az-2}"
  }

  tags = {
    Name = "${var.web-prefix}-${var.ecs-service-name}"
    Owner = var.owner-tag
  }
}

## app
resource "aws_ecs_service" "app-ecs-service" {
  name            = "${var.app-prefix}-${var.ecs-service-name}"
  cluster         = aws_ecs_cluster.ecs-cluster-app.id
  task_definition = aws_ecs_task_definition.app-ecs-service.arn
  desired_count   = 4
  #iam_role        = aws_iam_role.ecs-service-role.arn
  depends_on = [aws_ecs_task_definition.app-ecs-service,aws_ecs_cluster.ecs-cluster-app]

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.target-group-app.arn
    container_name   = "app-nginx-container"
    container_port   = 80
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone == ${var.az-1} || attribute:ecs.availability-zone == ${var.az-2}"
  }

  tags = {
    Name = "${var.app-prefix}-${var.ecs-service-name}"
    Owner = var.owner-tag
  }
}
