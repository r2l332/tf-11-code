resource "aws_vpc" "vpc_prod" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = "true"
  tags {
    Name = "PROD VPC"
  }
}

resource "aws_internet_gateway" "igw_prod" {
  vpc_id = "${aws_vpc.vpc_prod.id}"
  tags {
    Name = "Prod IGW"
  }
}

output "customer_vpc_prod_id" {
  value = "${aws_vpc.vpc_prod.id}"
}

###################################
# PUB route tables and subnet group
###################################

resource "aws_subnet" "prod_public_1" {
  vpc_id                  = "${aws_vpc.vpc_prod.id}"
  cidr_block              = "${var.prod_public_snet_1_cidr}"
  map_public_ip_on_launch = "true"
  availability_zone       = "${var.region}a"
  tags {
    Name = "Public Subnet 2a"
    Tier = "Public"
  }
}
output "prod_public_1_id" {
  value = "${aws_subnet.prod_public_1.id}"
}

resource "aws_route_table" "prod_public_rt_1" {
  vpc_id = "${aws_vpc.vpc_prod.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw_prod.id}"
  }
  tags {
    Name = "Prod Public RT 1"
  }
}

resource "aws_route_table_association" "prod_public_1" {
  subnet_id      = "${aws_subnet.prod_public_1.id}"
  route_table_id = "${aws_route_table.prod_public_rt_1.id}"
}

###################################
# PUB route tables and subnet group
###################################

resource "aws_subnet" "prod_public_2" {
  vpc_id                  = "${aws_vpc.vpc_prod.id}"
  cidr_block              = "${var.prod_public_snet_2_cidr}"
  map_public_ip_on_launch = "true"
  availability_zone       = "${var.region}b"
  tags {
    Name = "Public Subnet 2b"
    Tier = "Public"
  }
}
output "prod_public_2_id" {
  value = "${aws_subnet.prod_public_2.id}"
}

resource "aws_route_table" "prod_public_rt_2" {
  vpc_id = "${aws_vpc.vpc_prod.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw_prod.id}"
  }
  tags {
    Name = "Prod Public RT 2"
  }
}

resource "aws_route_table_association" "prod_public_2" {
  subnet_id      = "${aws_subnet.prod_public_2.id}"
  route_table_id = "${aws_route_table.prod_public_rt_2.id}"
}

#####################################
# NAT Gateway / Private Subnets / EIP
#####################################


resource "aws_eip" "prod_nat_ip" {
  vpc = true
}

resource "aws_nat_gateway" "prod_nat_gw" {
  subnet_id     = "${aws_subnet.prod_public_1.id}"
  allocation_id = "${aws_eip.prod_nat_ip.id}"
  tags {
    Name = "Prod NAT Gateway"
  }
}

##
## PRIV route tables and subnet group
##

resource "aws_subnet" "prod_customer_private_2" {
  vpc_id            = "${aws_vpc.vpc_prod.id}"
  cidr_block        = "${var.prod_private_snet_1_cidr}"
  availability_zone = "${var.region}a"
  tags {
    Name = "Private Subnet 2c"
    Tier = "Private_SNET"
  }
}
output "prod_customer_private_2_id" {
  value = "${aws_subnet.prod_customer_private_2.id}"
}

resource "aws_route_table" "prod_customer_private_rt_2" {
  vpc_id = "${aws_vpc.vpc_prod.id}"
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.prod_nat_gw.id}"
  }
  tags {
    Name = "Private RT 2"
  }
}

resource "aws_route_table_association" "prod_customer_private_2" {
  subnet_id      = "${aws_subnet.prod_customer_private_2.id}"
  route_table_id = "${aws_route_table.prod_customer_private_rt_2.id}"
}

####################################
# PRIV route tables and subnet group
###################################

resource "aws_subnet" "prod_customer_private_1" {
  vpc_id            = "${aws_vpc.vpc_prod.id}"
  cidr_block        = "${var.prod_private_snet_2_cidr}"
  availability_zone = "${var.region}b"
  tags {
    Name = "Private Subnet 2d"
    Tier = "Private_SNET"
  }
}
output "prod_customer_private_1_id" {
  value = "${aws_subnet.prod_customer_private_1.id}"
}

resource "aws_route_table" "prod_customer_private_rt_1" {
  vpc_id = "${aws_vpc.vpc_prod.id}"
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.prod_nat_gw.id}"
  }
  tags {
    Name = "Prod Private RT 1"
  }
}

resource "aws_route_table_association" "prod_customer_private_1" {
  subnet_id      = "${aws_subnet.prod_customer_private_1.id}"
  route_table_id = "${aws_route_table.prod_customer_private_rt_1.id}"
}

###################################
# RDS route tables and subnet group
###################################

resource "aws_db_subnet_group" "prod_rds" {
  name        = "${var.prod_rds_sg}"
  description = "Prod RDS Subnet Group"
  subnet_ids  = ["${aws_subnet.prod_public_1.id}", "${aws_subnet.prod_public_2.id}", "${aws_subnet.prod_customer_private_1.id}", "${aws_subnet.prod_customer_private_2.id}"]
  tags {
    Name = "Prod RDS Subnet"
  }
}
output "prod_rds_id" {
  value = "${aws_db_subnet_group.prod_rds.id}"
}
