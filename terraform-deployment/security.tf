# Adding GuardDuty
resource "aws_guardduty_detector" "c2_detector" {
  enable = true
}

# Adding CloudWatch Alarms
resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = "cpu-utilization-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.period
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Alarm when CPU exceeds 80%"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.commander_scaler_config_group.name
  }

  alarm_actions = [
    aws_autoscaling_policy.commander_scaler_policy.arn,
  ]
}

resource "aws_cloudwatch_metric_alarm" "failed_signin_alarm" {
  alarm_name          = "failed-console-signins"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "NumberOfFailedSignInAttempts"
  namespace           = "AWS/Signin"
  period              = var.period
  statistic           = "SampleCount"
  threshold           = 5
  alarm_description   = "This metric checks for 5 or more failed console sign-in attempts within a 5 minute period"
}

resource "aws_cloudwatch_metric_alarm" "authorization_failures_alarm" {
  alarm_name          = "authorization-failures"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "AuthorizationFailures"
  namespace           = "AWS/Events"
  period              = var.period
  statistic           = "SampleCount"
  threshold           = 20
  alarm_description   = "This metric checks for 20 or more authorization failures within a 5 minute period"
}

resource "aws_cloudwatch_metric_alarm" "exfil_alarm" {
  alarm_name          = "high-network-packets-out"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "NetworkPacketsOut"
  namespace           = "AWS/EC2"
  period              = var.period
  statistic           = "Average"
  threshold           = 10000
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.commander_scaler_config_group.name
  }
  alarm_description   = "This metric checks for an average of 10,000 or more network packets out within a 5 minute period over two consecutive periods"
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

resource "aws_acm_certificate" "commander_ssl" {
  private_key = file("8102key.pem")
  certificate_body = file("8102cert.pem")
}