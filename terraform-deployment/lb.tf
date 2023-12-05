resource "aws_lb" "c2_lb" {
  name               = "c2-lb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [aws_subnet.commander_subnet_a.id, aws_subnet.commander_subnet_b.id]
}

resource "aws_lb_listener" "c2_lb_listener" {
  load_balancer_arn = aws_lb.c2_lb.arn
  port              = var.http_port
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.c2_lb_tg.arn
     type             = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Bad Request - (automatic response)"
      status_code  = "400"
    }
  }
}

resource "aws_lb_target_group" "c2_lb_tg" {
  name = "c2-tg"
  port = var.http_port
  protocol = "HTTP"
  vpc_id = aws_vpc.vpc.id
}

resource "aws_lb_listener_rule" "to_c2" {
  listener_arn = aws_lb_listener.c2_lb_listener.arn
 
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.c2_lb_tg.arn
  }

  condition { 
    path_pattern {
      values = ["/"]
    }
  }
}