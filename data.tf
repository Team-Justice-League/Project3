data "aws_availability_zones" "availability_zone" {
  state         = "available"
  exclude_names = ["us-east-1-atl-1"]
}
data "aws_ssm_parameter" "instance_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-kernel-5.10-hvm-x86_64-gp2"
}
data "aws_iam_instance_profile" "S3Read" {
  name = "S3Read"
}

