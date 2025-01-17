resource "aws_launch_template" "template-app" {
  name          = var.launch-template-app-name
  image_id      = var.image-id
  instance_type = var.instance-type
  #key_name      = var.key-name
  key_name = data.aws_key_pair.existing_keypair.key_name
  
  
  iam_instance_profile {
    arn = "arn:aws:iam::381492154999:instance-profile/lhs-container-instance-role"
  }

  monitoring {
    enabled = true
  }

  lifecycle {
    create_before_destroy = true
  }


  network_interfaces {
    device_index    = 0
    security_groups = [aws_security_group.asg-security-group-app.id]
    
  }

 # 인스턴스 안에서 메타데이터 사용가능
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "optional"
    http_put_response_hop_limit = 2
  }


  user_data = base64encode(templatefile("app-user-data.sh",{
    ecs-cluster-name = "${var.app-prefix}-${var.ecs-cluster-name}"
  }))

   depends_on = [
    aws_db_instance.rds-db
  ]


  tag_specifications {

    resource_type = "instance"
    tags = {
      Name = var.app-instance-name
      Owner = var.owner-tag
    }
  }
}


locals {
  rds_endpoint = "${data.aws_db_instance.my_rds.endpoint}"
  host = replace(local.rds_endpoint, ":3306", "")
}