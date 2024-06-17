resource "aws_ecs_task_definition" "web-ecs-service" {
  family = "${var.web-prefix}-${var.ecs-family-name}"
  execution_role_arn = "arn:aws:iam::381492154999:role/lhs-ecs-taskExecutionRole"
  task_role_arn = "arn:aws:iam::381492154999:role/lhs-ecs-taskExecutionRole"
  
  requires_compatibilities = ["EC2"]

  runtime_platform {
   operating_system_family = "LINUX"
   cpu_architecture        = "X86_64"
 }

  container_definitions = jsonencode([
    {
      name      = "web-nginx-container"
      image     = "381492154999.dkr.ecr.ap-southeast-1.amazonaws.com/frontend:latest"   #3.0  381492154999.dkr.ecr.ap-southeast-1.amazonaws.com/frontend:latest
      cpu       = 20
      memory    = 256
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 0
          protocol      = "tcp"
        }
      ],
      "essential": true,
      environment = [
        {
          name = "ALB"
          value = "${aws_lb.alb-app.dns_name}"
        },
        {name = "AWS_REGION", value = var.region-name},
      ],
      logConfiguration = {
        logDriver = "awslogs",
        options   = {
          awslogs-create-group  = "true",
          awslogs-group        = aws_cloudwatch_log_group.log_group-web.name,
          awslogs-region       = var.region-name,
          awslogs-stream-prefix = var.web-prefix
        }
      },
     
    }


  ])
  

  volume {
    name      = "service-storage"
    host_path = "/ecs/service-storage"
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [${var.az-1}, ${var.az-2}]"
  }


  tags = {
    Name = "${var.web-prefix}-${var.ecs-task-definition}"
    Owner = var.owner-tag
  }
}

# app ECS task

resource "aws_ecs_task_definition" "app-ecs-service" {
  family = "${var.app-prefix}-${var.ecs-family-name}"
  execution_role_arn = "arn:aws:iam::381492154999:role/lhs-ecs-taskExecutionRole"
  task_role_arn = "arn:aws:iam::381492154999:role/lhs-ecs-taskExecutionRole"
  requires_compatibilities = ["EC2"]

  runtime_platform {
   operating_system_family = "LINUX"
   cpu_architecture        = "X86_64"
 }

  container_definitions = jsonencode([
    {
      name      = "app-nginx-container"
      image     = "381492154999.dkr.ecr.ap-southeast-1.amazonaws.com/backend:latest"  #latest 381492154999.dkr.ecr.ap-southeast-1.amazonaws.com/backend:latest
      cpu       = 20
      memory    = 256
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 0
        }
      ],
      "essential": true,
      environment = [
        {name = "rds_endpoint", value = "${data.aws_db_instance.my_rds.endpoint}"},
        {name = "HOST", value = "${local.host}"},
        {name = "USERNAME", value = "${var.db-username}"},
        {name = "PASSWORD", value = "${var.db-password}"},
        {name = "DB", value = "${var.db-name}"},
        {name = "AWS_REGION", value = var.region-name},
      ],
      logConfiguration = {
        logDriver = "awslogs",
        options   = {
          awslogs-create-group  = "true",
          awslogs-group        = aws_cloudwatch_log_group.log_group-app.name,
          awslogs-region       = var.region-name,
          awslogs-stream-prefix = var.app-prefix
        }
      },
      
    }
  ])
  volume {
    name      = "service-storage"
    host_path = "/ecs/service-storage"
  }
  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [${var.az-1}, ${var.az-2}]"
  }


  tags = {
    Name = "${var.app-prefix}-${var.ecs-task-definition}"
    Owner = var.owner-tag
  }
}

