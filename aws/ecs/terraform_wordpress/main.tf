#########################
# @ Terraform
# @ By Lee Jelley
# @ Date 22/01/2018
#########################

provider "aws" {
  region = "${var.region}"

  ###############################
  # .aws/credentials stored local
  ###############################

  shared_credentials_file = "/root/.aws/credentials"

  profile = "awscli_profile_name"

  ##########################
  # Manual AWS Credentials
  ##########################

  #access_key = "${var.access_key}"
  #secret_key = "${var.secret_key}"
}

module "vpc_subnets" {
  source                   = "./vpc"
  vpc_cidr                 = "${var.vpc_cidr}"
  region                   = "${var.region}"
  prod_rds_sg              = "${var.prod_rds_sg}"
  prod_rds_sg_local        = "${var.prod_rds_sg_local}"
  prod_public_snet_1_cidr  = "${var.prod_public_snet_1_cidr}"
  prod_public_snet_2_cidr  = "${var.prod_public_snet_2_cidr}"
  prod_private_snet_1_cidr = "${var.prod_private_snet_1_cidr}"
  prod_private_snet_2_cidr = "${var.prod_private_snet_2_cidr}"
  customer_vpc_prod_id     = "${module.vpc_subnets.customer_vpc_prod_id}"
  local-ips                = "${var.local-ips}"
  prod_allow_web_id        = "${module.vpc_subnets.prod_allow_web_id}"
  prod_mem_sg_local        = "${var.prod_mem_sg_local}"
  prod_mem_sg              = "${var.prod_mem_sg}"
}

module "rds_instances" {
  source                     = "./rds"
  prod_customer_name         = "${var.prod_customer_name}"
  rds_backup_period          = "${var.rds_backup_period}"
  prod_rds_name              = "${var.prod_rds_name}"
  rds_engine                 = "${var.rds_engine}"
  rds_engine_version         = "${var.rds_engine_version}"
  rds_instance_type          = "${var.rds_instance_type}"
  rds_replica_type           = "${var.rds_replica_type}"
  dbusername                 = "${var.dbusername}"
  dbpassword                 = "${var.dbpassword}"
  prod_rds_sg_local_id       = "${module.vpc_subnets.prod_rds_sg_local_id}"
  prod_rds_id                = "${module.vpc_subnets.prod_rds_id}"
  prod_rds_sg_id             = "${module.vpc_subnets.prod_rds_sg_id}"
  prod_mem_sg_local_id       = "${module.vpc_subnets.prod_mem_sg_local_id}"
  prod_mem_sg_id             = "${module.vpc_subnets.prod_mem_sg_id}"
  skip_f_snap                = "${var.skip_f_snap}"
  multi_az                   = "${var.multi_az}"
  storage                    = "${var.storage}"
  mem_engine                 = "${var.mem_engine}"
  mem_type                   = "${var.mem_type}"
  mem_port                   = "${var.mem_port}"
  cache_nodes                = "${var.cache_nodes}"
  mem_az                     = "${var.mem_az}"
  customer_vpc_prod_id       = "${module.vpc_subnets.customer_vpc_prod_id}"
  prod_customer_private_1_id = "${module.vpc_subnets.prod_customer_private_1_id}"
  prod_customer_private_2_id = "${module.vpc_subnets.prod_customer_private_2_id}"
  region                     = "${var.region}"
}

module "ec2_instances" {
  source                        = "./ec2"
  prod_external_allow_access_id = "${module.vpc_subnets.prod_external_allow_access_id}"
  prod_allow_web_id             = "${module.vpc_subnets.prod_allow_web_id}"
  amis                          = "${var.amis}"
  bastion_ami                   = "${var.bastion_ami}"
  region                        = "${var.region}"
  prod_customer_private_1_id    = "${module.vpc_subnets.prod_customer_private_1_id}"
  prod_customer_private_2_id    = "${module.vpc_subnets.prod_customer_private_2_id}"
  prod_public_1_id              = "${module.vpc_subnets.prod_public_1_id}"
  prod_public_2_id              = "${module.vpc_subnets.prod_public_2_id}"
  instance_type                 = "${var.instance_type}"
  instance_type_bastion         = "${var.instance_type_bastion}"
  ec2_name                      = "${var.ec2_name}"
  key_name                      = "${var.key_name}"
  asg_max                       = "${var.asg_max}"
  asg_min                       = "${var.asg_min}"
  asg_desired                   = "${var.asg_desired}"
  availability_zones            = "${var.availability_zones}"
  lb_type                       = "${var.lb_type}"
  lb_term                       = "${var.lb_term}"
  p_lc                          = "${var.p_lc}"
  f_delete                      = "${var.f_delete}"
  proto                         = "${var.proto}"
  port                          = "${var.port}"
  customer_vpc_prod_id          = "${module.vpc_subnets.customer_vpc_prod_id}"
  lb_tg_name                    = "${var.lb_tg_name}"
  efs_performance               = "${var.efs_performance}"
  customer_efs                  = "${var.customer_efs}"
  prod_customer_name            = "${var.prod_customer_name}"
  counter                       = "${var.counter}"
  prod_memcache_cluster_ep      = "${module.rds_instances.prod_memcache_cluster_ep}"
  prod_rds_instance_ep          = "${module.rds_instances.prod_rds_instance_ep}"
  prod_lb_web_id                = "${module.vpc_subnets.prod_lb_web_id}"
  prod_bastion_ssh_id           = "${module.vpc_subnets.prod_bastion_ssh_id}"
  dbusername                    = "${var.dbusername}"
  dbpassword                    = "${var.dbpassword}"
  False                         = "${var.False}"
  True                          = "${var.True}"
  ng-port                       = "${var.ng-port}"
  wp-port                       = "${var.wp-port}"
  customer                      = "${var.customer}"
  vol_size                      = "${var.vol_size}"
  template                      = "${var.template}"
  wp-content                    = "${var.wp-content}"
  email                         = "${var.email}"
  admin                         = "${var.admin}"
  description                   = "${var.description}"
  url                           = "${var.url}"
  title                         = "${var.title}"
  theme_ss                      = "${var.theme_ss}"
  wp_max_mem                    = "${var.wp_max_mem}"
  wp_mem                        = "${var.wp_mem}"
  c_status                      = "${var.c_status}"
  delay                         = "${var.delay}"
}
