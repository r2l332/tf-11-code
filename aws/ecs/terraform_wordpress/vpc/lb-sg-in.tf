resource "aws_security_group" "prod_lb_web" {
  name        = "prod_lb_web"
  description = "Allow inbound Web traffic from my LB"
  vpc_id      = "${var.customer_vpc_prod_id}"

  ingress {
    to_port         = 0
    from_port       = 0
    protocol        = "-1"
    security_groups = ["${var.prod_allow_web_id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "Prod Allow HTTP From Loadbalancer"
  }
}
output "prod_lb_web_id" {
  value = "${aws_security_group.prod_lb_web.id}"
}
