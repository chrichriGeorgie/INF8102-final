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