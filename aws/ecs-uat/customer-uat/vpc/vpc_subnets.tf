resource "aws_vpc" "customer_vpc" {
  cidr_block = "${var.vpc_cidr}"
}

resource "aws_internet_gateway" "customer_igw" {
  vpc_id = "${aws_vpc.customer_vpc.id}"
  tags {
    Name = "customer_igw"
  }
}

output "customer_vpc_id" {
  value = "${aws_vpc.customer_vpc.id}"
}

##
## UAT route tables and subnet group
##

resource "aws_subnet" "uat_public_1" {
  vpc_id                  = "${aws_vpc.customer_vpc.id}"
  cidr_block              = "${var.public_snet_cidr}"
  map_public_ip_on_launch = "true"
  availability_zone       = "${var.region}c"
  tags {
    Name = "Subnet 2a"
  }
}
output "uat_public_1_id" {
  value = "${aws_subnet.uat_public_1.id}"
}

resource "aws_route_table" "uat_public_1" {
  vpc_id = "${aws_vpc.customer_vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.customer_igw.id}"
  }
  tags {
    Name = "uat_subnet_1_route_table"
  }
}

resource "aws_route_table_association" "uat_public_1" {
  subnet_id      = "${aws_subnet.uat_public_1.id}"
  route_table_id = "${aws_route_table.uat_public_1.id}"
}

##
## UAT route tables and subnet group
##

resource "aws_subnet" "uat_public_2" {
  vpc_id                  = "${aws_vpc.customer_vpc.id}"
  cidr_block              = "${var.public_snet_2_cidr}"
  map_public_ip_on_launch = "true"
  availability_zone       = "${var.region}d"
  tags {
    Name = "Subnet 2a"
  }
}
output "uat_public_2" {
  value = "${aws_subnet.uat_public_2.id}"
}

resource "aws_route_table" "uat_public_2" {
  vpc_id = "${aws_vpc.customer_vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.customer_igw.id}"
  }
  tags {
    Name = "uat_subnet_2_route_table"
  }
}

resource "aws_route_table_association" "uat_public_2" {
  subnet_id      = "${aws_subnet.uat_public_2.id}"
  route_table_id = "${aws_route_table.uat_public_2.id}"
}

##
## RDS route tables and subnet group
##

resource "aws_db_subnet_group" "uat_rds" {
  name        = "${var.rds_sg_sn_name}"
  description = "Casepoint RDS Subnet Group"
  subnet_ids  = ["${aws_subnet.uat_public_1.id}", "${aws_subnet.uat_public_2.id}"]
  tags {
    Name = "rds_subnet_group"
  }
}
output "uat_rds_id" {
  value = "${aws_db_subnet_group.uat_rds.id}"
}
