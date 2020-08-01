resource "aws_security_group" "prod_bastion_ssh" {
  name        = "prod_bastion_ssh"
  description = "Prod Allow inbound Web traffic from my LB"
  vpc_id      = "${var.customer_vpc_prod_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.prod_public_snet_1_cidr}", "${var.prod_public_snet_2_cidr}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "Prod Allow SSH From Bastion"
  }
}
output "prod_bastion_ssh_id" {
  value = "${aws_security_group.prod_bastion_ssh.id}"
}
