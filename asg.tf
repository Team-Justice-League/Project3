resource "aws_autoscaling_group" "Justice-League-ASG" {
  name                      = "Justice-League-ASG"
  max_size                  = 4
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 2
  force_delete              = true
  vpc_zone_identifier       = [aws_subnet.public[0].id, aws_subnet.public[1].id]
  target_group_arns         = [aws_lb_target_group.polly-TG.arn]

  launch_template {
    id      = aws_launch_template.polly-LT.id
    version = aws_launch_template.polly-LT.latest_version
  }


  tag {
    key                 = "Name"
    value               = "${var.default_tags.env}-ASG"
    propagate_at_launch = true
  }

  timeouts {
    delete = "3m"
  }

  tag {
    key                 = "Name"
    value               = "${var.default_tags.env}-ASG"
    propagate_at_launch = true
  }
}
