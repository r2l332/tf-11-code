resource "aws_security_group" "allow_web" {
  name        = "allow_all"
  description = "Allow inbound Web traffic from my LB"
  vpc_id      = "${var.customer_vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "Allow HTTP/HTTPS From External"
  }
}
output "allow_web_id" {
  value = "${aws_security_group.allow_web.id}"
}
