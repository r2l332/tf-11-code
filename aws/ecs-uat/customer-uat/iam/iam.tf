resource "aws_iam_policy" "backup_role" {
  name   = "UATAssetPolicy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action":[
        "ec2:CreateSnapshot",
        "ec2:CreateTags",
        "ec2:DeleteSnapshot",
        "ec2:DescribeAvailabilityZones",
        "ec2:DescribeSnapshots",
        "ec2:DescribeTags",
        "ec2:DescribeVolumeAttribute",
        "ec2:DescribeVolumeStatus",
        "ec2:DescribeVolumes"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}
output "backup_role_id" {
  value = "${aws_iam_policy.backup_role.id}"
}

resource "aws_iam_policy" "s3_role" {
  name   = "ProdAssetPolicy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": [
        "arn:aws:s3:::casepoint-assets-uat",
        "arn:aws:s3:::casepoint-assets-uat/*"
      ]
    }
  ]
}
EOF
}

output "s3_role_id" {
  value = "${aws_iam_policy.s3_role.id}"
}

resource "aws_iam_policy" "CodeDeploy_role" {
  name   = "InitiateCodeDeploy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "codedeploy:GetDeploymentConfig",
      "Resource": "arn:aws:codedeploy:*:7546-3316-1911:deploymentconfig:*"
    },
    {
      "Effect": "Allow",
      "Action": "codedeploy:RegisterApplicationRevision",
      "Resource": "arn:aws:codedeploy:*:7546-3316-1911:application:*"
    },
    {
      "Action": [
        "codedeploy:Batch*",
        "codedeploy:CreateDeployment",
        "codedeploy:Get*",
        "codedeploy:List*",
        "codedeploy:RegisterApplicationRevision"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

output "CodeDeploy_role_id" {
  value = "${aws_iam_policy.CodeDeploy_role.id}"
}

#resource "aws_iam_instance_profile" "ec2_profiles" {
#    roles = ["${aws_iam_policy.backup_role.name}","${aws_iam_policy.CodeDeploy_role.name}"]#"${aws_iam_policy.s3_role.name}"
#}

#output "ec2_profiles_id" {
#  value = "${aws_iam_instance_profile.ec2_profiles.id}"
#}
