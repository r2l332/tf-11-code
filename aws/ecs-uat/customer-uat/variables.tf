variable "region" {
  default = "us-east-1"
}

variable "key_name" {
  default = "<key-name>"
}

variable "ec2_name" {
  default = "<ec2_name>"
}

variable "amis" {
  default = "<ami-id>"
}

variable "instance_type" {
  default = "<instance-size>"
}

variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
  default     = "10.0.0.0/16"
}

variable "public_snet_cidr" {
  description = "CIDR for public subnet inside VPC"
  default     = "10.0.1.0/24"
}

variable "public_snet_2_cidr" {
  description = "CIDR for public subnet inside VPC"
  default     = "10.0.2.0/24"
}

variable "availability_zones" {
  default = ["us-east-1c", "us-east-1d"]
}

##
## RDS Variables
##

variable "dbpassword" {
  default = "<rds-password>"
}

variable "dbusername" {
  default = "<rds-username>"
}

variable "rds_instance_type" {
  default = "<rds-size>"
}

variable "rds_engine_version" {
  default = "5.6.27"
}

variable "rds_engine" {
  default = "mysql"
}

variable "rds_name" {
  default = "<rds-name>"
}

variable "rds_backup_period" {
  default = "7"
}

variable "rds_sg_sn_name" {
  default = "<rds-sg-name-1>"
}

variable "rds_sg_sn_local_name" {
  default = "<rds-sg-name-2>"
}

##
## S3 Buckets
##

variable "s3_bucket_name" {
  default = "<s3-baucket-name>"
}

variable "s3_bucket_region" {
  default = "us-east-1"
}

variable "s3_acl" {
  default = "private"
}

##
## IAM Profile
##

#variable "profile_name" {
#  default = "iam_profile"
#}
