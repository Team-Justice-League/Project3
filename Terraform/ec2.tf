# resource "aws_instance" "polly1" {
#   ami             = data.aws_ssm_parameter.instance_ami.value
#   instance_type   = "t3.micro"
#   key_name        = "Justice-League"
#   subnet_id       = aws_subnet.public[0].id
#   security_groups = [aws_security_group.justice-league-sg.id]
#   tags = {
#     "Name" = "${var.default_tags.env}-ec2-1"
#   }
#   user_data = base64encode(file("E:\\Tech\\SkillStorm\\DevOps\\Terraform\\project3\\user_data.sh"))

#   iam_instance_profile = data.aws_iam_instance_profile.S3Read.name
# }

# resource "aws_instance" "polly2" {
#   ami             = data.aws_ssm_parameter.instance_ami.value
#   instance_type   = "t3.micro"
#   key_name        = "Justice-League"
#   subnet_id       = aws_subnet.public[1].id
#   security_groups = [aws_security_group.justice-league-sg.id]
#   tags = {
#     "Name" = "${var.default_tags.env}-ec2-2"
#   }
#   user_data = base64encode(file("E:\\Tech\\SkillStorm\\DevOps\\Terraform\\project3\\user_data.sh"))

#   iam_instance_profile = data.aws_iam_instance_profile.S3Read.name
# }
