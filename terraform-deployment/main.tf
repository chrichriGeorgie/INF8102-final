provider "aws" {
  region = "ca-central-1"  # Set your desired AWS region
}

resource "aws_launch_configuration" "example" {
  name = "example_config"
  image_id = "ami-12345678"  # Specify the AMI ID of your VM image
  instance_type = "t2.micro"  # Specify the instance type

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello from the user data script!" > /tmp/user_data_output.txt
              # Add your custom script here or provide a script file URL
              EOF
}

resource "aws_autoscaling_group" "example" {
  desired_capacity     = 2
  max_size             = 4
  min_size             = 1
  launch_configuration = aws_launch_configuration.example.id

  tag {
    key                 = "Name"
    value               = "example-instance"
    propagate_at_launch = true
  }

  health_check_type          = "EC2"
  health_check_grace_period  = 300
}

resource "aws_lb" "external" {
  name               = "external-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["sg-0123456789abcdef0"]  # Specify your security group IDs
  subnets            = ["subnet-0123456789abcdef0", "subnet-0123456789abcdef1"]  # Specify your subnet IDs
}

resource "aws_lb" "internal" {
  name               = "internal-lb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = ["sg-0123456789abcdef1"]  # Specify your security group IDs
  subnets            = ["subnet-0123456789abcdef2", "subnet-0123456789abcdef3"]  # Specify your subnet IDs
}

resource "aws_lb_listener" "external" {
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

resource "aws_lb_listener" "internal" {
  load_balancer_arn = aws_lb.internal.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.internal.arn
    type             = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "OK"
      status_code  = "200"
    }
  }
}

resource "aws_lb_target_group" "external" {
  name     = "external-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-0123456789abcdef0"  # Specify your VPC ID
}

resource "aws_lb_target_group" "internal" {
  name     = "internal-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-0123456789abcdef0"  # Specify your VPC ID
}

resource "aws_lb_target_group_attachment" "external" {
  target_group_arn = aws_lb_target_group.external.arn
  target_id        = aws_autoscaling_group.example.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "internal" {
  target_group_arn = aws_lb_target_group.internal.arn
  target_id        = aws_autoscaling_group.example.id
  port             = 80
}

# Adding GuardDuty
resource "aws_guardduty_detector" "example" {
  enable = true
}

# Adding CloudWatch Alarms (Example: CPU Utilization Alarm)
resource "aws_cloudwatch_metric_alarm" "example" {
  alarm_name          = "example-cpu-utilization-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Alarm when CPU exceeds 80%"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.example.name
  }

  alarm_actions = [
    aws_autoscaling_policy.example.arn,
  ]
}
//resource "aws_autoscaling_policy" "example" {
//  name                   = "scale-up"
//  scaling_adjustment    = 1
//  cooldown              = 300
// adjustment_type       = "ChangeInCapacity"
//  cooldown_evaluation_periods = 2
//  scaling_adjustment_type     = "ChangeInCapacity"
//  scaling_target_id   = aws_autoscaling_policy.example.id
//}