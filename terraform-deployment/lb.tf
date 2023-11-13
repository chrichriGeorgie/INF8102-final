resource "aws_lb" "c2_lb" {
  name               = "external-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [""]  # Specify your security group IDs
  subnets            = [""]  # Specify your subnet IDs
}

resource "aws_lb_listener" "c2_lb" {
  load_balancer_arn = aws_lb.external.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.external.arn
    type             = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "OK"
      status_code  = "200"
    }
  }
}

resource "aws_lb_target_group" "c2_lb" {
  name     = "external-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-0123456789abcdef0"  # Specify your VPC ID
}


resource "aws_lb_target_group_attachment" "c2_lb" {
  target_group_arn = aws_lb_target_group.external.arn
  target_id        = aws_autoscaling_group.c2_lb.id
  port             = 80
}