resource "aws_security_group" "customer_allow_ssh" {
  name        = "allow_all"
  description = "Allow inbound SSH traffic from my IP"
  vpc_id      = "${var.customer_vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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
    Name = "Allow SSH and HTTP"
  }
}
output "customer_allow_ssh_id" {
  value = "${aws_security_group.customer_allow_ssh.id}"
}
