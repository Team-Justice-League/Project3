terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.30.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = var.default_tags
  }
}
# create vpc; CIDR 10.0.0.0/16
resource "aws_vpc" "main" {
  cidr_block                       = var.vpc_cidr
  assign_generated_ipv6_cidr_block = true
  enable_dns_hostnames             = true
  enable_dns_support               = true
  tags = {
    "Name" = "${var.default_tags.env}-VPC"
  }
}
#public subnets 10.0.0.0/24
resource "aws_subnet" "public" {
  count      = var.public_subnet_count
  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  # ipv6_cidr_block         = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, count.index)
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.availability_zone.names[count.index + 1]
  tags = {
    "Name" = "${var.default_tags.env}-Public-Subnet-${data.aws_availability_zones.availability_zone.names[count.index + 1]}"
  }
}
# private subnets 10.0.0.0/24
resource "aws_subnet" "private" {
  count             = var.private_subnet_count
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index + var.public_subnet_count)
  availability_zone = data.aws_availability_zones.availability_zone.names[count.index + 1]
  tags = {
    "Name" = "${var.default_tags.env}-Private-Subnet-${data.aws_availability_zones.availability_zone.names[count.index + 1]}"
  }
}
# IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    "Name" = "${var.default_tags.env}-IGW"
  }
}

#EIP
resource "aws_eip" "NAT_EIP" {
  vpc = true
}

# NGW
resource "aws_nat_gateway" "NAT_main" {
  allocation_id = aws_eip.NAT_EIP.id
  subnet_id     = aws_subnet.public.0.id
  tags = {
    Name = "${var.default_tags.env}-NGW"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  # depends_on = [aws_internet_gateway.igw]
}
# public route tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    "Name" = "${var.default_tags.env}-public_RT"
  }
}
# public routes
resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"
}

#public RT association  
resource "aws_route_table_association" "public" {
  count          = var.public_subnet_count
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

# private route tables
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = {
    "Name" = "${var.default_tags.env}-PrivateRT"
  }
}
# private routes
resource "aws_route" "private" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.NAT_main.id
}
resource "aws_route_table_association" "private" {
  count          = var.private_subnet_count
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}
