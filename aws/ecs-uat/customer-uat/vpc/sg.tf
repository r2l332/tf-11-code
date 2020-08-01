resource "aws_security_group" "customer_allow_ssh" {
  name        = "allow_all"
  description = "Allow inbound SSH traffic from my IP"
  vpc_id      = "${var.customer_vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["212.69.42.60/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "Allow SSH"
  }
}
output "customer_allow_ssh_id" {
  value = "${aws_security_group.customer_allow_ssh.id}"
}

resource "aws_security_group" "customer_http_inbound_sg" {
  name        = "customer_http_inbound"
  description = "Allow HTTP from Anywhere"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["212.69.42.60/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = "${var.customer_vpc_id}"
  tags {
    Name = "customer_http_inbound"
  }
}
output "customer_http_inbound_sg_id" {
  value = "${aws_security_group.customer_http_inbound_sg.id}"
}

resource "aws_security_group" "customer_https_inbound_sg" {
  name        = "customer_https_inbound"
  description = "Allow HTTPS from Anywhere"
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["212.69.42.60/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = "${var.customer_vpc_id}"
  tags {
    Name = "customer_https_inbound"
  }
}
output "customer_https_inbound_sg_id" {
  value = "${aws_security_group.customer_https_inbound_sg.id}"
}

resource "aws_security_group" "rds_sg" {
  name        = "${var.rds_sg_sn_name}"
  description = "Allow access to MySQL RDS"
  vpc_id      = "${var.customer_vpc_id}"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["34.195.208.0/32"]
  }
  egress {
    from_port   = 1024
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "customer_rds_inbound"
  }
}

output "rds_sg_id" {
  value = "${aws_security_group.rds_sg.id}"
}

resource "aws_security_group" "rds_sg_local" {
  name        = "${var.rds_sg_sn_local_name}"
  description = "Allow access to MySQL RDS"
  vpc_id      = "${var.customer_vpc_id}"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${var.public_snet_cidr}", "${var.public_snet_2_cidr}"]
  }
  egress {
    from_port   = 1024
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "customer_rds_local_inbound"
  }
}

output "rds_sg_local_id" {
  value = "${aws_security_group.rds_sg_local.id}"
}
