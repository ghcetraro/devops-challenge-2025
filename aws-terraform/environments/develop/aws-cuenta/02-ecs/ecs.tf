#
resource "aws_ecs_cluster" "cluster" {
  name = var.cluster.name
  tags = local.tags
  configuration {
    execute_command_configuration {
      logging = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.cluster.name
      }
    }
  }
}
#
resource "aws_ecs_task_definition" "app_task" {
  for_each = var.services
  family   = lookup(each.value, "name", each.key)
  container_definitions = jsonencode([
    {
      name      = lookup(each.value, "name", each.key)
      image     = "${aws_ecr_repository.app_ecr_repo[each.key].repository_url}:${lookup(each.value, "tag")}"
      essential = lookup(each.value, "essential", true)
      portMappings = [
        {
          containerPort = lookup(each.value, "containerPort", 80)
          hostPort      = lookup(each.value, "hostPort", 80)
          protocol      = "tcp"
        }
      ],
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = lookup(each.value, "name", each.key)
          awslogs-region        = "${var.region}"
          awslogs-stream-prefix = "ecs"
        }
      },
      memory = lookup(each.value, "memory", 256)
      cpu    = lookup(each.value, "cpu", 256)
      environment = [
        { name = "APP_ENV", value = "development" }
      ]
    }
  ])
  #
  requires_compatibilities = ["FARGATE"]                       # use Fargate as the launch type
  network_mode             = "awsvpc"                          # add the AWS VPN network mode as this is required for Fargate
  memory                   = lookup(each.value, "memory", 512) # Specify the memory the container requires
  cpu                      = lookup(each.value, "cpu", 256)    # Specify the CPU the container requires
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  task_role_arn            = aws_iam_role.ecsTaskExecutionRole.arn
  depends_on = [
    aws_iam_role.ecsTaskExecutionRole,
  ]
  #
  tags = merge(
    { td_version = var.cluster.td_version },
    local.tags
  )
}

##########################
#
resource "aws_ecs_service" "app_service" {
  for_each                           = var.services
  name                               = lookup(each.value, "name", each.key)
  cluster                            = aws_ecs_cluster.cluster.id                     # Reference the created Cluster
  task_definition                    = aws_ecs_task_definition.app_task[each.key].arn # Reference the task that the service will spin up
  launch_type                        = "FARGATE"
  desired_count                      = lookup(each.value, "desired_count", 1)
  deployment_minimum_healthy_percent = lookup(each.value, "deployment_minimum_healthy_percent", 50)
  deployment_maximum_percent         = lookup(each.value, "deployment_maximum_percent", 200)
  enable_ecs_managed_tags            = lookup(each.value, "enable_ecs_managed_tags", true)
  #
  network_configuration {
    security_groups  = ["${aws_security_group.service_security_group.id}"] # Set up the security group
    subnets          = ["${var.vpc.subnets_0}", "${var.vpc.subnets_1}"]
    assign_public_ip = false # Provide the containers with public IPs
  }
  #
  load_balancer {
    target_group_arn = aws_lb_target_group.app[each.key].arn
    container_name   = lookup(each.value, "name", each.key)
    container_port   = lookup(each.value, "containerPort", 80)
  }
  lifecycle {
    create_before_destroy = false
  }
  #
  deployment_circuit_breaker {
    enable   = false
    rollback = false
  }
  #
  deployment_controller {
    type = "ECS"
  }
  #
  depends_on = [
    resource.aws_ecs_cluster.cluster,
    resource.aws_ecr_repository.app_ecr_repo,
    aws_ecs_cluster.cluster,
    aws_ecs_task_definition.app_task,
    aws_security_group.service_security_group
  ]
  tags = local.tags
}
#
# Create a security group for the ecs
resource "aws_security_group" "service_security_group" {
  name        = "${var.project}-${var.environment}-SG-ECS"
  description = "Allow traffic"
  vpc_id      = var.vpc.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    { Name = "${var.project}-${var.environment}-SG-ECS" },
    local.tags
  )
}
#
########################## load balancer ##################################################
#
# Create a security group for the load balancer:
resource "aws_security_group" "load_balancer_security_group_public" {
  name        = "${var.account}-${var.environment}-SG-ECS-ALB-PUBLIC"
  description = "Allow traffic"
  vpc_id      = var.vpc.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    { Name = "${var.project}-${var.environment}-SG-ECS-ALB-PUBLIC" },
    local.tags
  )
}
#
resource "aws_lb" "main_public" {
  name               = "${var.project}-${var.environment}-ECS-PUBLIC"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load_balancer_security_group_public.id]
  subnets            = ["${var.vpc.subnets_2}", "${var.vpc.subnets_3}"]

  enable_deletion_protection = false

  tags = merge(
    { Name = "${var.project}-${var.environment}-ALB-ECS-PUBLIC" },
    local.tags
  )

  depends_on = [
    aws_security_group.load_balancer_security_group_public
  ]
}
#
resource "aws_lb_target_group" "app" {
  for_each    = var.services
  name        = lookup(each.value, "short_name", each.key)
  port        = lookup(each.value, "hostPort", 80)
  protocol    = "HTTP"
  vpc_id      = var.vpc.vpc_id
  target_type = "ip"
  #
  health_check {
    path                = "/health"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
  #
  tags = local.tags
}
#
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main_public.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Not Found"
      status_code  = "404"
    }
  }
}
#
resource "aws_lb_listener_rule" "app" {
  for_each     = var.services
  listener_arn = aws_lb_listener.http.arn
  priority     = lookup(each.value, "priority", 1)

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app[each.key].arn
  }

  condition {
    host_header {
      values = lookup(each.value, "url", each.key)
    }
  }
  tags = local.tags
}