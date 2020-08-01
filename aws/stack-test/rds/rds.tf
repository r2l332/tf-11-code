resource "aws_db_instance" "rds_instance" {
  identifier              = "${var.customer_name}-db"
  allocated_storage       = "${var.storage}"
  engine                  = "${var.rds_engine}"
  engine_version          = "${var.rds_engine_version}"
  instance_class          = "${var.rds_instance_type}"
  name                    = "${var.rds_name}"
  username                = "${var.dbusername}"
  password                = "${var.dbpassword}"
  backup_retention_period = "${var.rds_backup_period}"
  multi_az                = "${var.multi_az}"
  db_subnet_group_name    = "${var.rds_id}"
  vpc_security_group_ids  = ["${var.rds_sg_id}", "${var.rds_sg_local_id}"]
  skip_final_snapshot     = "${var.skip_f_snap}"
}
