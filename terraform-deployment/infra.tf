resource "aws_launch_configuration" "commander_scaler_config" {
  name = "commander_scaler_config"
  image_id = "ami-0fc5d935ebf8bc3bc"  # Ubuntu 22.04 LTS x86_64
  instance_type = "t2.micro" # Limitation
  
  user_data = templatefile("setup.sh.tftpl", {})
}

resource "aws_autoscaling_group" "commander_scaler_config_group" {
  # These values are here for our project's demonstration purposes. In a real setting they could be augmented.
  desired_capacity     = 2
  max_size             = 4
  min_size             = 1
  launch_configuration = aws_launch_configuration.commander_scaler_config.id
  target_group_arns = [aws_lb.c2_lb.arn]
}

resource "aws_autoscaling_policy" "commander_scaler_policy" {
  name = "c2-scale"
  autoscaling_group_name = aws_autoscaling_group.commander_scaler_config_group.name
  policy_type = "SimpleScaling"
  adjustment_type = "ChangeInCapacity"
  scaling_adjustment = 1
  cooldown  = var.period
}

resource "aws_dynamodb_table" "c2_db" {
  name           = "CommanderDB"
  hash_key       = "UserId"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "UserId"
    type = "S"
  }
}