######################
# Provider Credentials 
######################

variable "access_key" {
  default = "NONE"
}

variable "secret_key" {
  default = "NONE"
}

################
# EC2 / ASG / LC 
################

variable "asg_min" {
  default = "1"
}

variable "asg_max" {
  default = "3"
}

variable "asg_desired" {
  default = "1"
}

variable "region" {
  default = "AWS_REGION"
}

variable "private_key_path" {
  default = "KEY_PATH"
}

variable "key_name" {
  default = "KEY_NAME"
}

variable "ec2_name" {
  default = "INSTANCE_NAME"
}

variable "amis" {
  default = "AWS_AMI"
}

variable "instance_type" {
  default = "EC2_SIZE"
}

variable "lb_type" {
  default = "LB_TYPE_APPLICATION_OR_NETWORK"
}

variable "lb_term" {
  default = "YES_NO"
}

variable "p_lc" {
  default = "YES_NO"
}

variable "f_delete" {
  default = "YES_NO"
}

variable "port" {
  default = "80"
}

variable "proto" {
  default = "HTTP"
}

variable "lb_tg_name" {
  default = "TARGET_NAME"
}

variable "efs_performance" {
  default = "generalPurpose"
}

variable "customer_efs" {
  default = "EFS_NAME"
}

variable "counter" {
  default = "2"
}

#############
# VPC / SNET
#############

variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
  default     = "10.0.0.0/16"
}

variable "public_snet_1_cidr" {
  description = "CIDR for public subnet inside VPC"
  default     = "10.0.1.0/24"
}

variable "public_snet_2_cidr" {
  description = "CIDR for public subnet inside VPC"
  default     = "10.0.2.0/24"
}

variable "private_snet_1_cidr" {
  description = "CIDR for private subnet inside VPC"
  default     = "10.0.3.0/24"
}

variable "private_snet_2_cidr" {
  description = "CIDR for private subnet inside VPC"
  default     = "10.0.4.0/24"
}

variable "availability_zones" {
  default = "AZ_1,AZ_2,AZ_3"
}

variable "local-ips" {
  default = "LOCAL_IP,LOCAL_IP,LOCAL_IP,LOCAL_IP,LOCAL_IP"
}

variable "customer_name" {
  default = "ACCOUNT_NAME"
}

###############
# RDS Variables
###############

variable "dbpassword" {
  default = "DBPASS"
}

variable "dbusername" {
  default = "DBUSER"
}

variable "rds_instance_type" {
  default = "RDS_SIZE"
}

variable "rds_engine_version" {
  default = "5.6.27"
}

variable "rds_engine" {
  default = "mysql"
}

variable "rds_name" {
  default = "RDS_NAME"
}

variable "rds_backup_period" {
  default = "7"
}

variable "rds_sg" {
  default = "RDS_SG_NAME"
}

variable "rds_sg_local" {
  default = "RDS_SG_NAME"
}

variable "skip_f_snap" {
  default = "false"
}

variable "multi_az" {
  default = "false"
}

variable "storage" {
  default = "10"
}

############
# S3 Buckets
############

variable "s3_bucket_name" {
  default = "S3_NAME"
}

variable "s3_bucket_region" {
  default = "S3_REGION"
}

variable "s3_acl" {
  default = "private"
}
