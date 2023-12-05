resource "aws_launch_configuration" "commander_scaler_config" {
  name = "commander_scaler_config"
  image_id = "ami-0fc5d935ebf8bc3bc"  # Ubuntu 22.04 LTS x86_64
  instance_type = "t2.micro" # Limitation
  key_name = var.key_pair
  security_groups = [ aws_security_group.commander_sg.id ]
  iam_instance_profile = aws_iam_instance_profile.commander_profile.id
  associate_public_ip_address = true

  user_data = templatefile("setup.sh.tftpl", {})
}

resource "aws_autoscaling_group" "commander_scaler_config_group" {
  # These values are here for our project's demonstration purposes. In a real setting they could be augmented.
  desired_capacity     = 2
  max_size             = 4
  min_size             = 1
  launch_configuration = aws_launch_configuration.commander_scaler_config.id
  target_group_arns = [aws_lb_target_group.c2_lb_tg.id]
  vpc_zone_identifier = [aws_subnet.commander_subnet_a.id, aws_subnet.commander_subnet_b.id]
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
  name           = "INF8102_TP_Final"
  hash_key       = "UserId"
  range_key = "EntryID"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5

  attribute {
    name = "UserId"
    type = "S"
  }

  attribute {
    name = "EntryID"
    type = "S"
  }
}

resource "aws_lambda_function" "redirector" {
  filename = data.archive_file.redirect_zip.output_path
  function_name = "redirector_lambda"
  role = "arn:aws:iam::088239126423:role/LabRole"
  handler = "redirector.redirector"
  runtime = "python3.7"
  timeout = 15
  
  vpc_config {
    subnet_ids = [ aws_subnet.lambda_subnet.id ]
    security_group_ids = [aws_security_group.redirector_sg.id]
  }
  
  environment {
    variables = {
      LOADBLCIP = "${aws_lb.c2_lb.dns_name}"
    }
  }
}