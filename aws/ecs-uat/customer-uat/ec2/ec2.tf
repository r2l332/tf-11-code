resource "aws_instance" "csp_web" {
  ami           = "${var.amis}"
  instance_type = "${var.instance_type}"
  tags = {
    Name = "${var.ec2_name}"
  }
  subnet_id                   = "${var.uat_public_1_id}"
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${var.customer_allow_ssh_id}"]
  key_name                    = "${var.key_name}"
  #iam_instance_profile = "${var.ec2_profiles_id}"
}

resource "aws_eip" "csp_web" {
  instance = "${aws_instance.csp_web.id}"
  vpc      = true
}

output "csp_web_id" {
  value = "${aws_eip.csp_web.id}"
}
