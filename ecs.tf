resource "aws_ecs_cluster" "hmh_cluster" {
  name = "hmh-cluster"
}

resource "aws_ecs_task_definition" "hmh_web_task" {
  family                   = "hmh-web-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "hmh-web"
      image     = aws_ecr_repository.app_repos["hmh/web"].repository_url
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}


resource "aws_ecs_service" "hmh_web_service" {
  name            = "hmh-web-service"
  cluster         = aws_ecs_cluster.hmh_cluster.id
  task_definition = aws_ecs_task_definition.hmh_web_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = data.aws_subnets.main.ids
    security_groups = [aws_security_group.ecs_tasks_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.hmh_web_tg.arn
    container_name   = "hmh-web"
    container_port   = 80
  }

  depends_on = [aws_lb_listener.hmh_web_listener]
}

resource "aws_ecs_task_definition" "other_tasks" {
  for_each                 = toset(["hmh/app", "hmh/frontend", "hmh/db"])
  family                   = "${replace(each.key, "/", "-")}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = each.key
      image     = aws_ecr_repository.app_repos[each.key].repository_url
      portMappings = []
    }
  ])
}

resource "aws_ecs_service" "other_services" {
  for_each        = toset(["hmh/app", "hmh/frontend", "hmh/db"])
  name            = "${replace(each.key, "/", "-")}-service"
  cluster         = aws_ecs_cluster.hmh_cluster.id
  task_definition = aws_ecs_task_definition.other_tasks[each.key].arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = data.aws_subnets.main.ids
    security_groups = [aws_security_group.internal_ecs_tasks_sg.id]
  }
}
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

