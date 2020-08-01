######################
# Provider Credentials 
######################

#variable "access_key" {
#  default = "NONE"
#}

#variable "secret_key" {
#  default = "NONE"
#}

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
  default = "3"
}

variable "region" {
  default = "AWS_REGION"
}

#variable "private_key_path" {
#  default = "NULL"
#}

variable "key_name" {
  default = "KEY_NAME"
}

variable "ec2_name" {
  default = "EC2_NAME"
}

variable "amis" {
  default = "ECS_AMI"
}

variable "instance_type" {
  default = "EC2_TYPE"
}

variable "bastion_ami" {
  default = "EC2_AMI"
}

variable "instance_type_bastion" {
  default = "EC2_TYPE"
}

variable "lb_type" {
  default = "application"
}

variable "lb_term" {
  default = "false"
}

variable "delay" {
  default = "120"
}

variable "p_lc" {
  default = "true"
}

variable "f_delete" {
  default = "true"
}

variable "port" {
  default = "80"
}

variable "proto" {
  default = "HTTP"
}

variable "lb_tg_name" {
  default = "LB_TARGET_GROUP_NAME"
}

variable "efs_performance" {
  default = "generalPurpose"
}

variable "customer_efs" {
  default = "EFS_NAME"
}

variable "customer" {
  default = "CUSTOMER_NAME"
}

variable "counter" {
  default = "2"
}

variable "True" {
  default = "true"
}

variable "False" {
  default = "false"
}

variable "wp-port" {
  default = "WORDPRESS_CNT_PORT"
}

variable "ng-port" {
  default = "NGINX_CNT_PORT"
}

variable "vol_size" {
  default = "100"
}

#############
# VPC / SNET
#############

variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
  default     = "10.0.0.0/16"
}

variable "prod_public_snet_1_cidr" {
  description = "CIDR for public subnet inside VPC"
  default     = "10.0.1.0/24"
}

variable "prod_public_snet_2_cidr" {
  description = "CIDR for public subnet inside VPC"
  default     = "10.0.2.0/24"
}

variable "prod_private_snet_1_cidr" {
  description = "CIDR for private subnet inside VPC"
  default     = "10.0.3.0/24"
}

variable "prod_private_snet_2_cidr" {
  description = "CIDR for private subnet inside VPC"
  default     = "10.0.4.0/24"
}

variable "availability_zones" {
  default = "AVAILABILITY_ZONES_COMMA_SEPERATED"
}

variable "local-ips" {
  default = "COMMA_SEPERATED_IP_RANGES"
}

variable "prod_customer_name" {
  default = "CUSTOMER_NAME_PROD"
}

###############
# WP ENV
###############

variable "template" {
  default = "WP_TEMPLATE"
}

variable "wp-content" {
  default = "WP_CONTENT_URL"
}

variable "email" {
  default = "EMAIL_ADDRESS"
}

variable "admin" {
  default = "admin"
}

variable "description" {
  default = "WP_DESCRIPTION"
}

variable "url" {
  default = "WP_URL"
}

variable "title" {
  default = "WP_TITLE"
}

variable "theme_ss" {
  default = "WP_THEME_STYLE_SHEET"
}

variable "c_status" {
  default = "closed"
}

variable "wp_mem" {
  default = "256M"
}

variable "wp_max_mem" {
  default = "256M"
}

###############
# RDS Variables
###############

variable "dbpassword" {
  default = "DB_PASSWORD"
}

variable "dbusername" {
  default = "DB_USERNAME"
}

variable "rds_instance_type" {
  default = "RDS_TYPE"
}

variable "rds_replica_type" {
  default = "RDS_REP_TYPE"
}

variable "rds_engine_version" {
  default = "5.6.27"
}

variable "rds_engine" {
  default = "mysql"
}


variable "prod_rds_name" {
  default = "RDS_NAME"
}

variable "rds_backup_period" {
  default = "7"
}

variable "prod_rds_sg" {
  default = "rds-prod-sg"
}

variable "prod_rds_sg_local" {
  default = "rds-prod-sg-local"
}

variable "skip_f_snap" {
  default = "false"
}

variable "multi_az" {
  default = "true"
}

variable "storage" {
  default = "50"
}

variable "mem_instance_type" {
  default = "MEMCACHE_TYPE"
}

variable "mem_engine" {
  default = "memcached"
}

variable "mem_az" {
  default = "cross_az"
}

variable "mem_port" {
  default = "11211"
}

variable "cache_nodes" {
  default = "2"
}

variable "mem_type" {
  default = "MEMCACHE_TYPE"
}

variable "prod_mem_sg" {
  default = "mem-prod-sg"
}

variable "prod_mem_sg_local" {
  default = "mem-prod-sg-local"
}
