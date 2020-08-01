##########################
# Applictaion Loadbalancer
##########################

resource "aws_lb" "prod-customer-elb" {
  name                       = "${var.prod_customer_name}-lb"
  internal                   = false
  subnets                    = ["${var.prod_public_2_id}", "${var.prod_public_1_id}"]
  enable_deletion_protection = "${var.lb_term}"
  security_groups            = ["${var.prod_allow_web_id}"]
}

output "prod-customer-elb" {
  value = "${aws_lb.prod-customer-elb.dns_name}"
}

resource "aws_lb_target_group" "prod-customer-tg" {
  name                 = "${var.lb_tg_name}"
  port                 = "${var.port}"
  protocol             = "${var.proto}"
  vpc_id               = "${var.customer_vpc_prod_id}"
  deregistration_delay = "${var.delay}"
  health_check {
    interval            = 30
    timeout             = 20
    healthy_threshold   = 3
    unhealthy_threshold = 2
    matcher             = "200,301,302"
  }
}

resource "aws_lb_listener" "prod-customer-elb" {
  load_balancer_arn = "${aws_lb.prod-customer-elb.arn}"
  port              = "${var.port}"
  protocol          = "${var.proto}"
  default_action {
    target_group_arn = "${aws_lb_target_group.prod-customer-tg.arn}"
    type             = "forward"
  }
}

##########################################
# Autoscaling Group / Launch Configuration
##########################################

resource "aws_autoscaling_policy" "prod-customer_sp_up" {
  name                   = "${var.prod_customer_name}-scaling-policy-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.prod-customer-asg.name}"
}

resource "aws_cloudwatch_metric_alarm" "prod-customer_alarm_up" {
  alarm_name          = "terraform-test-foobar5"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "75"

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.prod-customer-asg.name}"
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.prod-customer_sp_up.arn}"]
}

resource "aws_autoscaling_policy" "prod-customer_sp_down" {
  name                   = "${var.prod_customer_name}-scaling-policy-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.prod-customer-asg.name}"
}

resource "aws_cloudwatch_metric_alarm" "prod-customer_alarm_down" {
  alarm_name          = "${var.prod_customer_name}-scale-down"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "15"

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.prod-customer-asg.name}"
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.prod-customer_sp_down.arn}"]
}

resource "aws_autoscaling_group" "prod-customer-asg" {
  name                 = "${var.ec2_name}"
  max_size             = "${var.asg_max}"
  min_size             = "${var.asg_min}"
  desired_capacity     = "${var.asg_desired}"
  force_delete         = "${var.f_delete}"
  launch_configuration = "${aws_launch_configuration.prod-web-lc.name}"
  vpc_zone_identifier  = ["${var.prod_customer_private_1_id}", "${var.prod_customer_private_2_id}"]
  enabled_metrics      = ["GroupTerminatingInstances", "GroupMaxSize", "GroupDesiredCapacity", "GroupPendingInstances", "GroupInServiceInstances", "GroupMinSize", "GroupTotalInstances"]
  lifecycle {
    create_before_destroy = true
  }
  tag {
    key                 = "Name"
    value               = "${var.ec2_name}"
    propagate_at_launch = "${var.p_lc}"
  }
}

resource "aws_autoscaling_attachment" "prod-customer-asg" {
  autoscaling_group_name = "${aws_autoscaling_group.prod-customer-asg.id}"
  alb_target_group_arn   = "${aws_lb_target_group.prod-customer-tg.arn}"
}

resource "aws_launch_configuration" "prod-web-lc" {
  name                 = "${var.prod_customer_name}-lc"
  image_id             = "${var.amis}"
  iam_instance_profile = "${aws_iam_instance_profile.prod_web_profile.name}"
  instance_type        = "${var.instance_type}"
  security_groups      = ["${aws_security_group.prod_nfs-mnt.id}", "${var.prod_lb_web_id}", "${var.prod_bastion_ssh_id}"]
  key_name             = "${var.key_name}"
  user_data            = "#!/bin/bash\necho ECS_CLUSTER=${aws_ecs_cluster.prod-customer-cluster.name} >> /etc/ecs/ecs.config\necho '${aws_efs_file_system.customer_efs.dns_name}: /mnt nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,_netdev 0 0' >> /etc/fstab\nsudo yum install nfs-utils -y && sudo mount -a\nmkdir -p /mnt/{env,uploads}\necho 'export DB_HOST=${var.prod_rds_instance_ep}' >> /mnt/env/localenv\necho 'export DB_USER=${var.dbusername}' >> /mnt/env/localenv\necho 'export DB_PASSWORD=${var.dbpassword}' >> /mnt/env/localenv\necho 'export MEMCACHE_SERVER=${var.prod_memcache_cluster_ep}' >> /mnt/env/localenv\necho 'export DB_NAME=${var.customer}' >> /mnt/env/localenv\necho 'export WORDPRESS_TEMPLATE=${var.template}'>> /mnt/env/localenv\necho 'export WP_CONTENT_URL=${var.url}wp-content' >> /mnt/env/localenv\necho 'export WORDPRESS_ADMIN_EMAIL=${var.email}' >> /mnt/env/localenv\necho 'export WORDPRESS_ADMIN_USER=${var.admin}' >> /mnt/env/localenv\necho 'export WORDPRESS_DESCRIPTION=${var.description}' >> /mnt/env/localenv\necho 'export WP_SITEURL=${var.url}' >> /mnt/env/localenv\necho 'export WORDPRESS_TITLE=${var.title}' >> /mnt/env/localenv\necho 'export WORDPRESS_COMMENT_STATUS=${var.c_status}' >> /mnt/env/localenv\necho 'export WORDPRESS_STYLESHEET=${var.theme_ss}' >> /mnt/env/localenv\necho 'export WP_MEMORY_LIMIT=${var.wp_mem}' >> /mnt/env/localenv\necho 'export WP_MAX_MEMORY_LIMIT=${var.wp_max_mem}' >> /mnt/env/localenv\necho 'export WP_HOME=${var.url}' >> /mnt/env/localenv\necho 'export DISABLE_WP_CRON=${var.True}' >> /mnt/env/localenv\necho 'export FORCE_SSL_ADMIN=${var.False}' >> /mnt/env/localenv\necho 'export DB_CHARSET=utf8' >> /mnt/env/localenv\necho 'export TABLE_PREFIX=wp_' >> /mnt/env/localenv\necho 'export DISALLOW_FILE_EDIT=${var.True}' >> /mnt/env/localenv\nawk '!seen[$0]++' /mnt/env/localenv > /mnt/env/local.env\nrm -f /mnt/env/localenv\nchmod 440 /mnt/env/local.env"
  lifecycle {
    create_before_destroy = true
  }
  root_block_device {
    volume_size           = "${var.vol_size}"
    delete_on_termination = "${var.False}"
  }
}

##########################################
# Bastion Server
##########################################

resource "aws_instance" "prod_bastion" {
  ami           = "${var.bastion_ami}"
  instance_type = "${var.instance_type_bastion}"
  tags = {
    Name = "${var.prod_customer_name}-bastion"
  }
  subnet_id                   = "${var.prod_public_1_id}"
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${var.prod_external_allow_access_id}"]
  key_name                    = "${var.key_name}"
}

resource "aws_eip" "prod-bastion-eip" {
  instance = "${aws_instance.prod_bastion.id}"
  vpc      = true
}

output "prod-bastion-eip_id" {
  value = "${aws_eip.prod-bastion-eip.id}"
}

##########################################
# ECS Cluster
##########################################


resource "aws_ecs_cluster" "prod-customer-cluster" {
  name = "ecs${title(var.prod_customer_name)}Cluster"
}

resource "aws_ecs_task_definition" "prod-customer-wordpress" {
  family                = "${var.prod_customer_name}-ecs-wp"
  container_definitions = "${file("/root/ecs_project/prod/ec2/task/wp.json")}"
  volume {
    name      = "uploads"
    host_path = "/mnt/uploads"
  }
  volume {
    name      = "env"
    host_path = "/mnt/env"
  }
  volume {
    name = "droot"
  }
}

resource "aws_ecs_service" "prod-customer-svc-wordpress" {
  name                               = "${var.prod_customer_name}-wordpress"
  cluster                            = "${aws_ecs_cluster.prod-customer-cluster.id}"
  task_definition                    = "${aws_ecs_task_definition.prod-customer-wordpress.arn}"
  desired_count                      = 5
  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 25
  placement_strategy {
    type  = "spread"
    field = "host"
  }
  load_balancer {
    container_name   = "varnish"
    container_port   = "6081"
    target_group_arn = "${aws_lb_target_group.prod-customer-tg.arn}"
  }
}

resource "aws_appautoscaling_target" "prod_ecs_target" {
  max_capacity       = 10
  min_capacity       = 2
  resource_id        = "service/${aws_ecs_cluster.prod-customer-cluster.name}/${aws_ecs_service.prod-customer-svc-wordpress.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "prod-customer_ecs_policy_up" {
  name               = "${var.prod_customer_name}-ecs-policy"
  resource_id        = "service/${aws_ecs_cluster.prod-customer-cluster.name}/${aws_ecs_service.prod-customer-svc-wordpress.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  policy_type        = "TargetTrackingScaling"
  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    scale_in_cooldown  = 120
    scale_out_cooldown = 120
    target_value       = 70
  }
  depends_on = ["aws_appautoscaling_target.prod_ecs_target"]
}
