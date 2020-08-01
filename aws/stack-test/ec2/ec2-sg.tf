##########################
# Applictaion Loadbalancer
##########################

resource "aws_lb" "docker-elb" {
  name                       = "${var.customer_name}-lb"
  internal                   = false
  subnets                    = ["${var.public_1_id}", "${var.public_2_id}"]
  enable_deletion_protection = "${var.lb_term}"
  security_groups            = ["${var.allow_web_id}"]
}

output "docker-elb" {
  value = "${aws_lb.docker-elb.dns_name}"
}

resource "aws_lb_target_group" "docker-tg" {
  name     = "${var.lb_tg_name}"
  port     = "${var.port}"
  protocol = "${var.proto}"
  vpc_id   = "${var.customer_vpc_id}"
}

resource "aws_lb_listener" "docker-elb" {
  load_balancer_arn = "${aws_lb.docker-elb.arn}"
  port              = "${var.port}"
  protocol          = "${var.proto}"
  default_action {
    target_group_arn = "${aws_lb_target_group.docker-tg.arn}"
    type             = "forward"
  }
}

##########################################
# Autoscaling Group / Launch Configuration
##########################################


resource "aws_autoscaling_group" "docker-asg" {
  name                 = "${var.ec2_name}"
  max_size             = "${var.asg_max}"
  min_size             = "${var.asg_min}"
  desired_capacity     = "${var.asg_desired}"
  force_delete         = "${var.f_delete}"
  launch_configuration = "${aws_launch_configuration.web-lc.name}"
  vpc_zone_identifier  = ["${var.public_1_id}", "${var.public_2_id}"]
  tag {
    key                 = "Name"
    value               = "${var.ec2_name}"
    propagate_at_launch = "${var.p_lc}"
  }
}

resource "aws_autoscaling_attachment" "docker-asg" {
  autoscaling_group_name = "${aws_autoscaling_group.docker-asg.id}"
  alb_target_group_arn   = "${aws_lb_target_group.docker-tg.arn}"
}

resource "aws_launch_configuration" "web-lc" {
  name                 = "${var.customer_name}-lc"
  image_id             = "${var.amis}"
  iam_instance_profile = "${aws_iam_instance_profile.web_profile.name}"
  instance_type        = "${var.instance_type}"
  security_groups      = ["${var.external_allow_access_id}", "${aws_security_group.nfs-mnt.id}"]
  key_name             = "${var.key_name}"
}
