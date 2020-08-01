provider "aws" {
  region = "${var.region}"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}

module "vpc_subnets" {
  source = "./vpc"
  vpc_cidr = "${var.vpc_cidr}"
  region = "${var.region}"
  public_snet_cidr = "${var.public_snet_cidr}"
  public_snet_2_cidr = "${var.public_snet_2_cidr}"
  customer_vpc_id = "${module.vpc_subnets.customer_vpc_id}"
}

module "ec2_instances" {
  source = "./ec2"
  customer_allow_ssh_id = "${module.vpc_subnets.customer_allow_ssh_id}"
  amis = "${var.amis}"
  region = "${var.region}"
  uat_public_1_id = "${module.vpc_subnets.uat_public_1.id}"
  uat_public_2_id = "${module.vpc_subnets.uat_public_2.id}"
  private_key_path = "${var.private_key_path}"
  instance_type = "${var.instance_type}"
  ec2_name = "${var.ec2_name}"
  key_name = "${var.key_name}"
}
