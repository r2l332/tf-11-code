resource "aws_security_group" "prod_external_allow_access" {
  name        = "prod_allow_all_from_jf"
  description = "Prod Allow inbound traffic from EXT"
  vpc_id      = "${var.customer_vpc_prod_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${split(",", var.local-ips)}"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${split(",", var.local-ips)}"]
  }

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = ["${aws_security_group.prod_allow_web.id}"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${split(",", var.local-ips)}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "Prod Allow SSH/HTTP/HTTPS from EXT"
  }
}
output "prod_external_allow_access_id" {
  value = "${aws_security_group.prod_external_allow_access.id}"
}
