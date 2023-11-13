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

resource "aws_security_group" "commander_sg" {
  name   = "Commander Security Group"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = var.application_port
    to_port     = var.docker_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}