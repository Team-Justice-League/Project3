resource "aws_launch_template" "polly-LT" {
  name = "polly-LT"

  ebs_optimized = true

  iam_instance_profile {
    name = data.aws_iam_instance_profile.S3Read.name
  }

  instance_initiated_shutdown_behavior = "terminate"

  instance_market_options {
    market_type = "spot"
  }

  instance_type = "t3.micro"

  image_id = "ami-026b57f3c383c2eec"

  key_name = "Justice-League"

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "optional"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  monitoring {
    enabled = true
  }

  #   network_interfaces {
  #     associate_public_ip_address = true
  #   }

  vpc_security_group_ids = [aws_security_group.justice-league-sg.id]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.default_tags.env}-LT"
    }
  }

  user_data = base64encode(file("E:\\Tech\\SkillStorm\\DevOps\\Project3\\Terraform\\user_data.sh"))
}
