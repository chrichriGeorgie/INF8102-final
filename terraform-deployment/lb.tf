resource "aws_lb" "c2_lb" {
  name               = "c2-lb"
  internal           = false
  load_balancer_type = "network"
  security_groups    = [aws_security_group.commander_sg.id]
  subnets            = [aws_subnet.commander_subnet.id]
}

resource "aws_lb_listener" "c2_lb_listener" {
  load_balancer_arn = aws_lb.c2_lb.arn
  port              = var.application_port
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.c2_lb_tg.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group" "c2_lb_tg" {
  name = "c2-tg"
  port = var.application_port
  protocol = "TCP"
  vpc_id = aws_vpc.vpc.id
}


resource "aws_lb_target_group_attachment" "c2_lb_ga" {
  target_group_arn = aws_lb_target_group.c2_lb_tg.arn
  target_id        = aws_autoscaling_group.commander_scaler_config_group.id
  port             = var.application_port
}