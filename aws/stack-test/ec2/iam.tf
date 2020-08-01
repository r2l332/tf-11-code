#########################
# Policy Document Builder
#########################

data "aws_iam_policy_document" "backup" {
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

resource "aws_iam_policy" "backup_policy" {
  name   = "${var.customer_name}-backup"
  path   = "/"
  policy = "${data.aws_iam_policy_document.backup.json}"
}

output "backup_policy_id" {
  value = "${aws_iam_policy.backup_policy.id}"
}

data "aws_iam_policy_document" "cloudwatch" {
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

resource "aws_iam_policy" "cloudwatch_policy" {
  name   = "${var.customer_name}-cloudwatch"
  path   = "/"
  policy = "${data.aws_iam_policy_document.cloudwatch.json}"
}

output "cloudwatch_policy_id" {
  value = "${aws_iam_policy.cloudwatch_policy.id}"
}

data "aws_iam_policy_document" "codedeploy" {
  statement {
    effect = "Allow"
    actions = [
      "codedeploy:GetDeploymentConfig",
    ]

    resources = [
      "arn:aws:codedeploy:*:7546-3316-1911:deploymentconfig:*",
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "codedeploy:RegisterApplicationRevision",
    ]

    resources = [
      "arn:aws:codedeploy:*:7546-3316-1911:application:*",
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "codedeploy:Batch*",
      "codedeploy:CreateDeployment",
      "codedeploy:Get*",
      "codedeploy:List*",
      "codedeploy:RegisterApplicationRevision"
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "codedeploy_policy" {
  name   = "${var.customer_name}-codedeploy"
  path   = "/"
  policy = "${data.aws_iam_policy_document.codedeploy.json}"
}

output "codedeploy_policy_id" {
  value = "${aws_iam_policy.codedeploy_policy.id}"
}

data "aws_iam_policy_document" "cron" {
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

resource "aws_iam_policy" "cron_policy" {
  name   = "${var.customer_name}-cron"
  path   = "/"
  policy = "${data.aws_iam_policy_document.cron.json}"
}

output "cron_policy_id" {
  value = "${aws_iam_policy.cron_policy.id}"
}

######################
# Multi Policy builder
######################

resource "aws_iam_role" "web_policies" {
  name               = "${var.customer_name}-web_server_policy"
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

resource "aws_iam_role_policy_attachment" "cron_att" {
  role       = "${aws_iam_role.web_policies.name}"
  policy_arn = "${aws_iam_policy.cron_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "codedeploy_att" {
  role       = "${aws_iam_role.web_policies.name}"
  policy_arn = "${aws_iam_policy.codedeploy_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "backup_att" {
  role       = "${aws_iam_role.web_policies.name}"
  policy_arn = "${aws_iam_policy.backup_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "cloudwatch_att" {
  role       = "${aws_iam_role.web_policies.name}"
  policy_arn = "${aws_iam_policy.cloudwatch_policy.arn}"
}

resource "aws_iam_instance_profile" "web_profile" {
  name = "${var.customer_name}-web_server_profile"
  role = "${aws_iam_role.web_policies.name}"
}
