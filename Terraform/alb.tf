resource "aws_lb" "polly-ALB" {
  name               = "polly-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.justice-league-sg.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]
  tags = {
    "Name" = "${var.default_tags.env}-ALB"
  }
}

resource "aws_lb_target_group" "polly-TG" {
  name     = "polly-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_listener" "polly-ALB" {
  load_balancer_arn = aws_lb.polly-ALB.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.polly-TG.arn
  }
}

# resource "aws_lb_target_group_attachment" "polly-attach" {
#   target_group_arn = aws_lb_target_group.polly-TG.arn
#   target_id        = aws_lb_target_group.polly-TG.id
#   port             = 80
# }
