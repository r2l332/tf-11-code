resource "aws_db_instance" "prod_rds_instance" {
  identifier              = "${var.prod_customer_name}-db"
  allocated_storage       = "${var.storage}"
  engine                  = "${var.rds_engine}"
  engine_version          = "${var.rds_engine_version}"
  instance_class          = "${var.rds_instance_type}"
  name                    = "${var.prod_rds_name}"
  username                = "${var.dbusername}"
  password                = "${var.dbpassword}"
  backup_retention_period = "${var.rds_backup_period}"
  multi_az                = "${var.multi_az}"
  db_subnet_group_name    = "${var.prod_rds_id}"
  vpc_security_group_ids  = ["${var.prod_rds_sg_id}", "${var.prod_rds_sg_local_id}"]
  skip_final_snapshot     = "${var.skip_f_snap}"
}

resource "aws_db_instance" "prod_rds_replica" {
  replicate_source_db = "${aws_db_instance.prod_rds_instance.identifier}"
  identifier          = "${var.prod_customer_name}-replica-db"
  instance_class      = "${var.rds_instance_type}"
}

output "prod_rds_instance_ep" {
  value = "${aws_db_instance.prod_rds_instance.address}"
}

resource "aws_elasticache_subnet_group" "prod_memcache_snet" {
  name       = "${var.prod_customer_name}-memcache-snet"
  subnet_ids = ["${var.prod_customer_private_1_id}", "${var.prod_customer_private_2_id}"]
}

resource "aws_elasticache_parameter_group" "prod_memcached_pg" {
  family = "memcached1.4"
  name   = "${var.prod_customer_name}-memcached-pg"
}

resource "aws_elasticache_cluster" "prod_memcache_cluster" {
  cluster_id           = "${var.prod_customer_name}-cache"
  engine               = "${var.mem_engine}"
  node_type            = "${var.mem_type}"
  port                 = "${var.mem_port}"
  num_cache_nodes      = "${var.cache_nodes}"
  parameter_group_name = "${aws_elasticache_parameter_group.prod_memcached_pg.name}"
  availability_zones   = ["${var.region}a", "${var.region}b"]
  subnet_group_name    = "${aws_elasticache_subnet_group.prod_memcache_snet.name}"
  security_group_ids   = ["${var.prod_mem_sg_id}", "${var.prod_mem_sg_local_id}"]
}

output "prod_memcache_cluster_ep" {
  value = "${aws_elasticache_cluster.prod_memcache_cluster.cluster_address}"
}
