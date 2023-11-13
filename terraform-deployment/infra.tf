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

//resource "aws_autoscaling_policy" "example" {
//  name                   = "scale-up"
//  scaling_adjustment    = 1
//  cooldown              = 300
// adjustment_type       = "ChangeInCapacity"
//  cooldown_evaluation_periods = 2
//  scaling_adjustment_type     = "ChangeInCapacity"
//  scaling_target_id   = aws_autoscaling_policy.example.id
//}