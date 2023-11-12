provider "aws" {
  region = "ca-central-1"  # Canada Central Region Deployment
}

resource "aws_launch_configuration" "commander_scaler_config" {
  name = "commander_scaler_config"
  image_id = "ami-0fc5d935ebf8bc3bc"  # Ubuntu 22.04 LTS x86_64
  instance_type = "t2.micro" # Limitation

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello world!" > /tmp/user_data_output.txt
              EOF
}

resource "aws_autoscaling_group" "commander_scaler_config_group" {
  // These values are here for our project's demonstration purposes. In a real setting they could be augmented.
  desired_capacity     = 2
  max_size             = 4
  min_size             = 1
  launch_configuration = aws_launch_configuration.commander_scaler_config.id

//  tag {
//    key                 = "C"
//    value               = "example-instance"
//    propagate_at_launch = true
//  }

  health_check_type          = "EC2"
  health_check_grace_period  = 300
}

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

# Adding GuardDuty
resource "aws_guardduty_detector" "c2_detector" {
  enable = true
}

# Adding CloudWatch Alarms (Example: CPU Utilization Alarm)
resource "aws_cloudwatch_metric_alarm" "c2_alarm" {
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