variable "aws_ami_name" {
  default = "amzn-ami-hvm-2018.03.0.20181116-x86_64-gp2"
}
variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}
variable "region" {
  default = "ap-southeast-1"
}

provider "aws" {
  version    = "~> 1.50"
  access_key = "${var.aws_access_key_id}"
  secret_key = "${var.aws_secret_access_key}"
  region     = "${var.region}"
}

data "aws_ami" "aws-linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["${var.aws_ami_name}"]
  }

  owners = ["137112412989"] # AWS
}

resource "aws_security_group" "default_web_sg" {
  name        = "allow_web"
  description = "Allow http https inbound traffic"

  tags = {
    Name = "DevOps3-allow-web"
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}
    

resource "aws_security_group_rule" "ping_port" {
  type = "ingress"
  from_port = 8
  to_port = 0
  protocol = "icmp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.default_web_sg.id}"
}

resource "aws_security_group_rule" "ssh_port" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.default_web_sg.id}"
}

resource "aws_security_group_rule" "http_port" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.default_web_sg.id}"
}

resource "aws_security_group_rule" "https_port" {
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.default_web_sg.id}"
}

resource "aws_eip" "ip" {
  vpc = true
}

resource "aws_instance" "web_app" {
  ami           = "${data.aws_ami.aws-linux.id}"
  instance_type = "t2.micro"
  key_name      = "Enactor-Devops-3"
  vpc_security_group_ids = ["${aws_security_group.default_web_sg.id}"]

  root_block_device {
    volume_type = "standard"
    volume_size = "8"
    delete_on_termination = false
  }

  tags {
    Name = "DevOps3-webapp"
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = "${aws_instance.web_app.id}"
  allocation_id = "${aws_eip.ip.id}"
}
