provider "aws" {
  region = "${var.region}"
}

module "vpc_subnets" {
  source               = "/Users/<username>/terraform_iaac/customer-uat/vpc"
  vpc_cidr             = "${var.vpc_cidr}"
  rds_sg_sn_name       = "${var.rds_sg_sn_name}"
  rds_sg_sn_local_name = "${var.rds_sg_sn_local_name}"
  region               = "${var.region}"
  public_snet_cidr     = "${var.public_snet_cidr}"
  public_snet_2_cidr   = "${var.public_snet_2_cidr}"
  customer_vpc_id      = "${module.vpc_subnets.customer_vpc_id}"
}

module "iam_roles" {
  source = "/Users/<username>/terraform_iaac/customer-uat/iam"
  #profile_name = "${var.profile_name}"
}

module "ec2_instances" {
  source                = "/Users/<username>/terraform_iaac/customer-uat/ec2"
  customer_allow_ssh_id = "${module.vpc_subnets.customer_allow_ssh_id}"
  amis                  = "${var.amis}"
  region                = "${var.region}"
  uat_public_1_id       = "${module.vpc_subnets.uat_public_1_id}"
  instance_type         = "${var.instance_type}"
  key_name              = "${var.key_name}"
  #ec2_profiles_id = "${module.iam_roles.ec2_profiles_id}"
}

module "rds_instances" {
  source = "/Users/<username>/terraform_iaac/customer-uat/rds"
  #is_rds_multi_az = "${var.is_rds_multi_az}"
  #rds_backup_window = "${var.rds_backup_window}"
  rds_backup_period  = "${var.rds_backup_period}"
  rds_name           = "${var.rds_name}"
  rds_engine         = "${var.rds_engine}"
  rds_engine_version = "${var.rds_engine_version}"
  rds_instance_type  = "${var.rds_instance_type}"
  dbusername         = "${var.dbusername}"
  dbpassword         = "${var.dbpassword}"
  rds_sg_local_id    = "${module.vpc_subnets.rds_sg_local_id}"
  uat_rds_id         = "${module.vpc_subnets.uat_rds_id}"
  rds_sg_id          = "${module.vpc_subnets.rds_sg_id}"
}

module "s3_buckets" {
  source           = "/Users/<username>/terraform_iaac/customer-uat/s3"
  s3_bucket_name   = "${var.s3_bucket_name}"
  s3_bucket_region = "${var.s3_bucket_region}"
  s3_acl           = "${var.s3_acl}"
}
