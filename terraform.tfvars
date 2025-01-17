## REGION & Network 
region-name              = "ap-southeast-1" # ap-southeast-1
vpc-cidr-block           = "10.0.0.0/16"
vpc-name                 = "three-tier-vpc"
igw-name                 = "three-tier-igw"
nat-gw-name1              = "three-tier-nat-gw1"
nat-gw-name2              = "three-tier-nat-gw2"

## CIDR
public-subnet1-cidr         = "10.0.1.0/24"
public-subnet1-name         = "three-tier-public-subnet1"
public-subnet2-cidr         = "10.0.2.0/24"
public-subnet2-name         = "three-tier-public-subnet2"

## WEB
web-subnet1-cidr         = "10.0.3.0/24"
web-subnet1-name         = "three-tier-web-subnet-1"
web-subnet2-cidr         = "10.0.4.0/24"
web-subnet2-name         = "three-tier-web-subnet-2"

## WAS
app-subnet1-cidr         = "10.0.5.0/24"
app-subnet1-name         = "three-tier-app-subnet-1"
app-subnet2-cidr         = "10.0.6.0/24"
app-subnet2-name         = "three-tier-app-subnet-2"

## DB
db-subnet1-cidr          = "10.0.7.0/24"
db-subnet1-name          = "three-tier-db-subnet-1"
db-subnet2-cidr          = "10.0.8.0/24"
db-subnet2-name          = "three-tier-db-subnet-2"

## AZ & Routing Table
az-1                     = "ap-southeast-1a"
az-2                     = "ap-southeast-1c"
public-rt-name           = "three-tier-public-route-table"
private-rt-name1         = "three-tier-private-route-table1"
private-rt-name2         = "three-tier-private-route-table2"

launch-template-web-name = "three-tier-launch-template-web"
image-id                 = "ami-0709a71954f69cc26" # 최신 amazon linux2023 ami-id 고정. ecs-optimized  ami-0709a71954f69cc26

#ami-0b11193b5d8a12d1d
instance-type            = "t3.medium"

bastion-image-id         = "ami-0b287aaaab87c114d"

bastion-instance-type  = "t2.micro"

## Tag name

key-name                 = "3tier-key"
web-instance-name        = "three-tier-web-instances"
alb-web-name             = "three-tier-alb-web"
alb-sg-web-name          = "three-tier-alb-sg-web"
asg-web-name             = "threetier-asg-web"
asg-sg-web-name          = "three-tier-asg-sg-web"
tg-web-name              = "three-tier-tg-web"
launch-template-app-name = "three-tier-launch-template-app"
app-instance-name        = "three-tier-app-instances"
alb-app-name             = "three-tier-alb-app"
alb-sg-app-name          = "three-tier-alb-sg-app"
asg-app-name             = "threetier-asg-app"
asg-sg-app-name          = "three-tier-asg-sg-app"
tg-app-name              = "three-tier-tg-app"
db-name                  = "mydb"

instance-class           = "db.t3.micro"  # db 인스턴스 타입
db-sg-name               = "three-tier-db-sg"
db-subnet-grp-name       = "three-tier-db-subnet-grp"
app-db-sg-name           = "three-tier-app-db"

# iam role 이름
ecs_task_execution_role = "lhs-ecs-taskExecutionRole"
ecs-instance-role = "lhs-ecs-instanceRole"
ecs-service-role = "lhs-ecs-serviceRole"
ecs_task_role = "lhs-ecs-taskRole"

# 태그 설정(name, mark, environment)
owner-tag = "lhs"

#prefix 설정
dev-prefix = "dev"
test-prefix = "test"
prod-prefix = "prod"

web-prefix = "web"
app-prefix = "app"

# ECS Cluster Settings
ecs-cluster-name = "ecs-cluster"
ecs-capacity-provider = "capacity-provider"
ecs-ecr = "ecs-ecr"
ecs-task-definition = "ecs-task-def"
ecs-family-name = "ecs-family"
ecs-service-name = "ecs-service"

# cloudwatch
retention_in_days = 30 # 로그 보관 기간. 이후 삭제

# domain
domain-name = "mkcloud.site"