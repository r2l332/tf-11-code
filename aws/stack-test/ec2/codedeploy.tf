resource "aws_codedeploy_app" "customer_codedeploy" {
  name = "${var.customer_name}"
}
