#
# VPC
#
resource "aws_vpc" "main" {
  cidr_block = var.cidr
  tags = {
    Name = "${var.owner}_vpc_main"
    Owner = var.owner
  }
}
#
# Gateway Internet
#
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.owner}_internet_gw"
    Owner = var.owner
  }
}
#
# Gateway NAT
#
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.main.id
  subnet_id     = aws_subnet.public[0].id
  depends_on = [aws_internet_gateway.main]
  tags = {
    Name = "${var.owner}_nat_gateway"
    Owner = var.owner
  }
}
#
# IPs
#
resource "aws_eip" "main" {
  vpc = true
  tags = {
    Name = "${var.owner}_elastic_ip1"
    Owner = var.owner
  }
}
#
# Route tables
#
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "${var.owner}_rtable_public"
    Owner = var.owner
  }
}
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.main.id
  }
  tags = {
    Name = "${var.owner}_rtable_private"
    Owner = var.owner
  }
}
#
# Route table and Subnet association
#
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public[0].id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private[0].id
  route_table_id = aws_route_table.private.id
}
#
# Subnets Public
#
resource "aws_subnet" "public" {
  count      = length(var.public_subnets)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnets[count.index]
  tags = {
    Type = "Public"
    Name = "${var.owner}_subnet_public${count.index}"
    Owner = var.owner
  }
}
#
# Subnets Private
#
resource "aws_subnet" "private" {
  count      = length(var.private_subnets)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnets[count.index]
  tags = {
    Type = "Private"
    Name = "${var.owner}_subnet_private${count.index}"
    Owner = var.owner
  }
}
#
# Security Group
#
resource "aws_security_group" "default" {
  vpc_id      = aws_vpc.main.id
  ingress {
    description      = "HTTP"
    from_port        = 0
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = var.sg_web_allow_cidr
  }
  ingress {
    description      = "HTTPS"
    from_port        = 0
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = var.sg_web_allow_cidr
  }
  ingress {
    description      = "SSH"
    from_port        = 0
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = var.sg_ssh_allow_cidr
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.owner}_security_group"
    Owner = var.owner
  }
}