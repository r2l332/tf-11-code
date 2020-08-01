resource "aws_security_group" "prod_rds_sg" {
  name        = "${var.prod_rds_sg}"
  description = "Allow access to MySQL RDS"
  vpc_id      = "${var.customer_vpc_prod_id}"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${split(",", var.local-ips)}"]
  }
  egress {
    from_port   = 1024
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "RDS Inbound Access JFH"
  }
}

output "prod_rds_sg_id" {
  value = "${aws_security_group.prod_rds_sg.id}"
}

resource "aws_security_group" "prod_rds_sg_local" {
  name        = "${var.prod_rds_sg_local}"
  description = "Allow access to MySQL RDS"
  vpc_id      = "${var.customer_vpc_prod_id}"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${var.prod_public_snet_1_cidr}", "${var.prod_public_snet_2_cidr}", "${var.prod_private_snet_1_cidr}", "${var.prod_private_snet_2_cidr}"]
  }
  egress {
    from_port   = 1024
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "RDS Local Inbound Access"
  }
}

output "prod_rds_sg_local_id" {
  value = "${aws_security_group.prod_rds_sg_local.id}"
}

resource "aws_security_group" "prod_mem_sg" {
  name        = "${var.prod_mem_sg}"
  description = "Allow access to MySQL RDS"
  vpc_id      = "${var.customer_vpc_prod_id}"

  ingress {
    from_port   = 11211
    to_port     = 11211
    protocol    = "tcp"
    cidr_blocks = ["${split(",", var.local-ips)}"]
  }
  egress {
    from_port   = 1024
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "Memcached Inbound Access From JFH"
  }
}

output "prod_mem_sg_id" {
  value = "${aws_security_group.prod_mem_sg.id}"
}

resource "aws_security_group" "prod_mem_sg_local" {
  name        = "${var.prod_mem_sg_local}"
  description = "Allow access to MySQL RDS"
  vpc_id      = "${var.customer_vpc_prod_id}"

  ingress {
    from_port   = 11211
    to_port     = 11211
    protocol    = "tcp"
    cidr_blocks = ["${var.prod_public_snet_1_cidr}", "${var.prod_public_snet_2_cidr}", "${var.prod_private_snet_1_cidr}", "${var.prod_private_snet_2_cidr}"]
  }
  egress {
    from_port   = 1024
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "Memcached Local Inbound Access"
  }
}

output "prod_mem_sg_local_id" {
  value = "${aws_security_group.prod_mem_sg_local.id}"
}