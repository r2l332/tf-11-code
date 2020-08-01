####################
# AWS PROVIDER CREDS
####################

variable "access_key" {
  default = "NONE"
}

variable "secret_key" {
  default = "NONE"
}

#####################
# VPC / SNET / REGION 
#####################

variable "region" {
  default = "eu-central-1"
}

variable "private_key_path" {
  default = "KEY_PATH"
}

variable "key_name" {
  default = "KEY_NAME"
}

variable "ec2_name" {
  default = "docker_stack"
}

variable "amis" {
  default = "AMI"
}

variable "instance_type" {
  default = "t2.micro"
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
  default = ["eu-central-1a", "eu-central-1b"]
}
