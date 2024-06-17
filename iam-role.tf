

/*
# ECS task execution ROLE
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = var.ecs_task_execution_role
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"  # ECS 서비스에 대한 Principal
        },
        Action    = "sts:AssumeRole"
      }
    ]
  })
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  ]

  tags = {
    Name  = var.ecs_task_execution_role
    Owner = var.owner-tag
  }
}
*/


/*
resource "aws_iam_role" "ecs_task_execution_role" {
  name = var.ecs_task_execution_role

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  ]
}

resource "aws_iam_policy" "ecs_task_execution_policy" {
  name        = "lhs-ecs-task-execution-policy"
  description = "Policy for ECS task execution role to access necessary AWS services"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecs:DescribeTasks",
          "ecs:DescribeContainerInstances",
          "ecs:DescribeTaskDefinition",
          "ecs:ListTasks",
          "ecs:ListContainerInstances",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "xray:PutTelemetryRecords",
          "xray:PutTraceSegments"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeTags",
          "ec2:DescribeRegions"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_task_execution_policy.arn
  depends_on = [aws_iam_role.ecs_task_execution_role, aws_iam_policy.ecs_task_execution_policy]
}



# ECS task ROLE
resource "aws_iam_role" "ecs_task_role" {
  name               = var.ecs_task_role
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"  # ECS 서비스에 대한 Principal
        },
        Action    = "sts:AssumeRole"
      }
    ]
  })
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
  ]

  tags = {
    Name  = var.ecs_task_role
    Owner = var.owner-tag
  }
}
*/


#ECS service role
/*
resource "aws_iam_role" "ecs-service-role" {
  name               = var.ecs-service-role
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = {
        Service = "ecs.amazonaws.com"
      },
      Action    = "sts:AssumeRole"
    }]
  })
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSServiceRoleForECS"
  ]

  tags = {
    Name  = var.ecs-service-role
    Owner = var.owner-tag
  }
}
*/



/*
# EC2 -> ECS 접근 역할 설정(시작 템플릿) # EC2 것
resource "aws_iam_role" "ecs_instance_role" {
  name               = var.ecs-instance-role
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action    = "sts:AssumeRole"
    }]
  })

  tags = {
    Name  = var.ecs-instance-role
    Owner = var.owner-tag
  }
}


resource "aws_iam_policy_attachment" "ecs_instance_role_attachment" {
  name       = "ecsInstanceRoleAttachment"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
  roles      = [aws_iam_role.ecs_instance_role.name]
  depends_on = [aws_iam_role.ecs_instance_role]
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = var.ecs-instance-role
  role = aws_iam_role.ecs_instance_role.id
}
*/