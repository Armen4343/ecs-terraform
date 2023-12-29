resource "aws_security_group" "security_group" {
 name   = "ecs-security-group"
 vpc_id = aws_vpc.main.id

 ingress {
   from_port   = 0
   to_port     = 0
   protocol    = -1
   self        = "false"
   cidr_blocks = ["0.0.0.0/0"]
   description = "any"
 }

 egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}

resource "aws_ecs_cluster" "ecs_cluster" {
 name = "my-ecs-cluster"
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  family             = "my-ecs-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = var.task_execution_role
  container_definitions = jsonencode([
    {
   name        = "my-app"
   image       = var.image_name
   essential   = true
   portMappings = [{
     protocol      = "tcp"
     containerPort = 80
     hostPort      = 80
   }
   ]
    }
  ])
}

resource "aws_ecs_service" "ecs_service" {
 name                               = "ninth_wave_service"
 cluster                            = aws_ecs_cluster.ecs_cluster.id
 task_definition                    = aws_ecs_task_definition.ecs_task_definition.arn
 desired_count                      = 1
 deployment_minimum_healthy_percent = 0
 deployment_maximum_percent         = 200
 launch_type                        = "FARGATE"
 #force_new_deployment               = true
 
 network_configuration {
   security_groups  = [aws_security_group.security_group.id]
   subnets          = [aws_subnet.subnet.id]
   assign_public_ip = true
 }
}
