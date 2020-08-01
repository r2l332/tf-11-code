#########################
# @ Terraform StackDeploy
# @ By R2L332 -_-
# @ Date 23/01/2018
#########################

provider "aws" {
  region     = "${var.region}"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}

module "vpc_subnets" {
  source              = "./vpc"
  vpc_cidr            = "${var.vpc_cidr}"
  region              = "${var.region}"
  rds_sg              = "${var.rds_sg}"
  rds_sg_local        = "${var.rds_sg_local}"
  public_snet_1_cidr  = "${var.public_snet_1_cidr}"
  public_snet_2_cidr  = "${var.public_snet_2_cidr}"
  private_snet_1_cidr = "${var.private_snet_1_cidr}"
  private_snet_2_cidr = "${var.private_snet_2_cidr}"
  customer_vpc_id     = "${module.vpc_subnets.customer_vpc_id}"
  local-ips           = "${var.local-ips}"
}

module "s3_buckets" {
  source           = "./s3"
  s3_bucket_name   = "${var.s3_bucket_name}"
  s3_bucket_region = "${var.s3_bucket_region}"
  s3_acl           = "${var.s3_acl}"
}

module "rds_instances" {
  source             = "./rds"
  customer_name      = "${var.customer_name}"
  rds_backup_period  = "${var.rds_backup_period}"
  rds_name           = "${var.rds_name}"
  rds_engine         = "${var.rds_engine}"
  rds_engine_version = "${var.rds_engine_version}"
  rds_instance_type  = "${var.rds_instance_type}"
  dbusername         = "${var.dbusername}"
  dbpassword         = "${var.dbpassword}"
  rds_sg_local_id    = "${module.vpc_subnets.rds_sg_local_id}"
  rds_id             = "${module.vpc_subnets.rds_id}"
  rds_sg_id          = "${module.vpc_subnets.rds_sg_id}"
  skip_f_snap        = "${var.skip_f_snap}"
  multi_az           = "${var.multi_az}"
  storage            = "${var.storage}"
}

module "ec2_instances" {
  source                   = "./ec2"
  external_allow_access_id = "${module.vpc_subnets.external_allow_access_id}"
  allow_web_id             = "${module.vpc_subnets.allow_web_id}"
  amis                     = "${var.amis}"
  region                   = "${var.region}"
  public_1_id              = "${module.vpc_subnets.public_1_id}"
  public_2_id              = "${module.vpc_subnets.public_2_id}"
  private_key_path         = "${var.private_key_path}"
  instance_type            = "${var.instance_type}"
  ec2_name                 = "${var.ec2_name}"
  key_name                 = "${var.key_name}"
  asg_max                  = "${var.asg_max}"
  asg_min                  = "${var.asg_min}"
  asg_desired              = "${var.asg_desired}"
  availability_zones       = "${var.availability_zones}"
  lb_type                  = "${var.lb_type}"
  lb_term                  = "${var.lb_term}"
  p_lc                     = "${var.p_lc}"
  f_delete                 = "${f_delete}"
  proto                    = "${proto}"
  port                     = "${port}"
  customer_vpc_id          = "${module.vpc_subnets.customer_vpc_id}"
  lb_tg_name               = "${var.lb_tg_name}"
  efs_performance          = "${var.efs_performance}"
  customer_efs             = "${var.customer_efs}"
  customer_name            = "${var.customer_name}"
  counter                  = "${var.counter}"
}
