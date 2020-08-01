resource "aws_security_group" "rds_sg" {
  name        = "${var.rds_sg}"
  description = "Allow access to MySQL RDS"
  vpc_id      = "${var.customer_vpc_id}"

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

output "rds_sg_id" {
  value = "${aws_security_group.rds_sg.id}"
}

resource "aws_security_group" "rds_sg_local" {
  name        = "${var.rds_sg_local}"
  description = "Allow access to MySQL RDS"
  vpc_id      = "${var.customer_vpc_id}"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${var.public_snet_1_cidr}", "${var.public_snet_2_cidr}", "${var.private_snet_1_cidr}", "${var.private_snet_2_cidr}"]
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

output "rds_sg_local_id" {
  value = "${aws_security_group.rds_sg_local.id}"
}
