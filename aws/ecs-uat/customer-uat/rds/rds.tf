resource "aws_db_instance" "csp_uat" {
  allocated_storage       = 10
  engine                  = "${var.rds_engine}"
  engine_version          = "${var.rds_engine_version}"
  instance_class          = "${var.rds_instance_type}"
  name                    = "${var.rds_name}"
  username                = "${var.dbusername}"
  password                = "${var.dbpassword}"
  backup_retention_period = "${var.rds_backup_period}"
  #backup_window = "{var.rds_backup_window}"
  multi_az               = "false" #"{var.is_rds_multi_az}"
  db_subnet_group_name   = "${var.uat_rds_id}"
  vpc_security_group_ids = ["${var.rds_sg_id}", "${var.rds_sg_local_id}"]
}
