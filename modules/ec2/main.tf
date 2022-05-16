data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

resource "aws_network_interface" "main" {
  subnet_id   = var.subnet_id
  private_ips = var.private_ip
  tags = {
    Name = "${var.owner}_interface"
    Owner = var.owner
  }
}

resource "aws_key_pair" "main" {
  key_name   = "${var.owner}-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHf4u+DfeoXH0cPmlH41gWPZMKraXTOpsxjr5pyGZi66 denmarint@github"
  tags = {
    Name = "${var.owner}_instance"
    Owner = var.owner
  }
}

resource "aws_instance" "main" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.main.id

  network_interface {
    network_interface_id = aws_network_interface.main.id
    device_index         = 0
  }

  user_data = <<EOF
#!/bin/bash

sudo wget http://nginx.org/keys/nginx_signing.key
sudo apt-key add nginx_signing.key
cd /etc/apt
sudo cat >> sources.list <<EOD1
deb http://nginx.org/packages/ubuntu focal nginx
deb-src http://nginx.org/packages/ubuntu focal nginx
EOD1
sudo apt update
sudo apt install -y nginx vim
sudo systemctl start nginx.service
sudo systemctl enable nginx.service
sudo cat > /var/www/html/hello.html <<EOD2
Hello world!
EOD2

EOF

  tags = {
    Name = "${var.owner}_instance"
    Owner = var.owner
  }
}