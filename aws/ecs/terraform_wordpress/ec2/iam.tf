#########################
# Policy Document Builder
#########################

data "aws_iam_policy_document" "prod_ecs" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
      "ecs:CreateCluster",
      "ecs:DeregisterContainerInstance",
      "ecs:DiscoverPollEndpoint",
      "ecs:Poll",
      "ecs:RegisterContainerInstance",
      "ecs:StartTelemetrySession",
      "ecs:Submit*",
      "ecs:StartTask",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "prod_ecs_policy" {
  name   = "${var.prod_customer_name}-ecs"
  path   = "/"
  policy = "${data.aws_iam_policy_document.prod_ecs.json}"
}

output "prod_ecs_policy_id" {
  value = "${aws_iam_policy.prod_ecs_policy.id}"
}

data "aws_iam_policy_document" "prod_backup" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:CreateSnapshot",
      "ec2:CreateTags",
      "ec2:DeleteSnapshot",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeSnapshots",
      "ec2:DescribeTags",
      "ec2:DescribeVolumeAttribute",
      "ec2:DescribeVolumeStatus",
      "ec2:DescribeVolumes",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "prod_backup_policy" {
  name   = "${var.prod_customer_name}-backup"
  path   = "/"
  policy = "${data.aws_iam_policy_document.prod_backup.json}"
}

output "prod_backup_policy_id" {
  value = "${aws_iam_policy.prod_backup_policy.id}"
}

data "aws_iam_policy_document" "prod_cloudwatch" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
    ]

    resources = [
      "arn:aws:logs:*:*:*",
    ]
  }
}

resource "aws_iam_policy" "prod_cloudwatch_policy" {
  name   = "${var.prod_customer_name}-cloudwatch"
  path   = "/"
  policy = "${data.aws_iam_policy_document.prod_cloudwatch.json}"
}

output "prod_cloudwatch_policy_id" {
  value = "${aws_iam_policy.prod_cloudwatch_policy.id}"
}

data "aws_iam_policy_document" "prod_cron" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
      "cloudwatch:PutMetricData",
      "cloudwatch:GetMetricStatistics",
      "cloudwatch:ListMetrics",
      "ec2:DescribeTags",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "prod_cron_policy" {
  name   = "${var.prod_customer_name}-cron"
  path   = "/"
  policy = "${data.aws_iam_policy_document.prod_cron.json}"
}

output "prod_cron_policy_id" {
  value = "${aws_iam_policy.prod_cron_policy.id}"
}

######################
# Multi Policy builder
######################

resource "aws_iam_role" "prod_web_policies" {
  name               = "${var.prod_customer_name}-web_server_policies"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "prod_cron_att" {
  role       = "${aws_iam_role.prod_web_policies.name}"
  policy_arn = "${aws_iam_policy.prod_cron_policy.arn}"
}


resource "aws_iam_role_policy_attachment" "prod_backup_att" {
  role       = "${aws_iam_role.prod_web_policies.name}"
  policy_arn = "${aws_iam_policy.prod_backup_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "prod_ecs_att" {
  role       = "${aws_iam_role.prod_web_policies.name}"
  policy_arn = "${aws_iam_policy.prod_ecs_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "prod_cloudwatch_att" {
  role       = "${aws_iam_role.prod_web_policies.name}"
  policy_arn = "${aws_iam_policy.prod_cloudwatch_policy.arn}"
}


resource "aws_iam_instance_profile" "prod_web_profile" {
  name = "${var.prod_customer_name}-web_server_profile"
  role = "${aws_iam_role.prod_web_policies.name}"
}

############################
# Log Groups and Log Stream
############################

resource "aws_cloudwatch_log_group" "log-group-prod-wordpress" {
  name = "${var.customer}-prod-wordpress"
}

resource "aws_cloudwatch_log_stream" "log-stream-prod-wordpress" {
  name           = "${var.customer}-wp"
  log_group_name = "${aws_cloudwatch_log_group.log-group-prod-wordpress.name}"
}

resource "aws_cloudwatch_log_group" "log-group-prod-nginx" {
  name = "${var.customer}-prod-nginx"
}

resource "aws_cloudwatch_log_stream" "log-stream-prod-nginx" {
  name           = "${var.customer}-ng"
  log_group_name = "${aws_cloudwatch_log_group.log-group-prod-nginx.name}"
}

resource "aws_cloudwatch_log_group" "log-group-prod-varnish" {
  name = "${var.customer}-prod-varnish"
}

resource "aws_cloudwatch_log_stream" "log-stream-prod-varnish" {
  name           = "${var.customer}-var"
  log_group_name = "${aws_cloudwatch_log_group.log-group-prod-varnish.name}"
}
