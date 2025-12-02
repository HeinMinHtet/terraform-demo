resource "aws_lb" "hmh_web_lb" {
  name               = "hmh-web-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = data.aws_subnets.main.ids
}

resource "aws_lb_target_group" "hmh_web_tg" {
  name     = "hmh-web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.main.id
}

resource "aws_lb_listener" "hmh_web_listener" {
  load_balancer_arn = aws_lb.hmh_web_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.hmh_web_tg.arn
  }
}