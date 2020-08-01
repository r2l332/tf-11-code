###############
# List VPC SNET
###############

resource "aws_security_group" "prod_efs" {
  name        = "${var.prod_customer_name}-efs-sg"
  description = "Prod Allow traffic out to NFS."
  vpc_id      = "${var.customer_vpc_prod_id}"

  tags {
    Name = "PROD_NFS_OUT"
  }
}

resource "aws_security_group_rule" "prod_nfs-out" {
  type                     = "egress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.prod_efs.id}"
  source_security_group_id = "${aws_security_group.prod_nfs-mnt.id}"
}

resource "aws_security_group" "prod_nfs-mnt" {
  name        = "${var.prod_customer_name}-mnt-sg"
  description = "Prod Allow traffic from instances using."
  vpc_id      = "${var.customer_vpc_prod_id}"

  tags {
    Name = "PROD_NFS_MNT"
  }
}

resource "aws_security_group_rule" "prod_nfs-in" {
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.prod_efs.id}"
  source_security_group_id = "${aws_security_group.prod_nfs-mnt.id}"
}

data "aws_subnet_ids" "all_snets" {
  vpc_id = "${var.customer_vpc_prod_id}"
  tags {
    Tier = "Private_SNET"
  }
}

############
# Create EFS
############

resource "random_id" "prod_creation_token" {
  byte_length = 8
  prefix      = "${var.customer_efs}-"
}

resource "aws_efs_file_system" "customer_efs" {
  creation_token   = "${random_id.prod_creation_token.hex}"
  performance_mode = "${var.efs_performance}"
  tags {
    Name          = "${var.prod_customer_name}-efs"
    CreationToken = "${random_id.prod_creation_token.hex}"
  }
}

resource "aws_efs_mount_target" "prod_tg_efs" {
  count           = "${var.counter}"
  file_system_id  = "${aws_efs_file_system.customer_efs.id}"
  subnet_id       = "${element(data.aws_subnet_ids.all_snets.ids, count.index)}"
  security_groups = ["${aws_security_group.prod_efs.id}"]
}
