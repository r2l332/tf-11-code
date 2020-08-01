resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = "true"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags {
    Name = "IGW"
  }
}

output "customer_vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

###################################
# PUB route tables and subnet group
###################################

resource "aws_subnet" "public_1" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.public_snet_1_cidr}"
  map_public_ip_on_launch = "true"
  availability_zone       = "${var.region}a"
  tags {
    Name = "Subnet 2a"
    Tier = "All_Net"
  }
}
output "public_1_id" {
  value = "${aws_subnet.public_1.id}"
}

resource "aws_route_table" "public_rt_1" {
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
  tags {
    Name = "Public RT 1"
  }
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = "${aws_subnet.public_1.id}"
  route_table_id = "${aws_route_table.public_rt_1.id}"
}

###################################
# PUB route tables and subnet group
###################################

resource "aws_subnet" "public_2" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.public_snet_2_cidr}"
  map_public_ip_on_launch = "true"
  availability_zone       = "${var.region}b"
  tags {
    Name = "Subnet 2b"
    Tier = "All_Net"
  }
}
output "public_2_id" {
  value = "${aws_subnet.public_2.id}"
}

resource "aws_route_table" "public_rt_2" {
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
  tags {
    Name = "Public RT 2"
  }
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = "${aws_subnet.public_2.id}"
  route_table_id = "${aws_route_table.public_rt_2.id}"
}

#####################################
# NAT Gateway / Private Subnets / EIP
#####################################


resource "aws_eip" "nat_ip" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gw" {
  subnet_id     = "${aws_subnet.public_1.id}"
  allocation_id = "${aws_eip.nat_ip.id}"
  tags {
    Name = "NAT Gateway"
  }
}

##
## PRIV route tables and subnet group
##

resource "aws_subnet" "customer_private_2" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${var.private_snet_1_cidr}"
  availability_zone = "${var.region}c"
  tags {
    Name = "Subnet 2c"
    Tier = "All_Net"
  }
}
output "customer_private_2_id" {
  value = "${aws_subnet.customer_private_2.id}"
}

resource "aws_route_table" "customer_private_rt_2" {
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat_gw.id}"
  }
  tags {
    Name = "Private RT 2t"
  }
}

resource "aws_route_table_association" "customer_private_2" {
  subnet_id      = "${aws_subnet.customer_private_2.id}"
  route_table_id = "${aws_route_table.customer_private_rt_2.id}"
}

####################################
# PRIV route tables and subnet group
###################################

resource "aws_subnet" "customer_private_1" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${var.private_snet_2_cidr}"
  availability_zone = "${var.region}c"
  tags {
    Name = "Subnet 2d"
    Tier = "All_Net"
  }
}
output "customer_private_1_id" {
  value = "${aws_subnet.customer_private_1.id}"
}

resource "aws_route_table" "customer_private_rt_1" {
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat_gw.id}"
  }
  tags {
    Name = "Private RT 1"
  }
}

resource "aws_route_table_association" "customer_private_1" {
  subnet_id      = "${aws_subnet.customer_private_1.id}"
  route_table_id = "${aws_route_table.customer_private_rt_1.id}"
}

###################################
# RDS route tables and subnet group
###################################

resource "aws_db_subnet_group" "rds" {
  name        = "${var.rds_sg}"
  description = "RDS Subnet Group"
  subnet_ids  = ["${aws_subnet.public_1.id}", "${aws_subnet.public_2.id}", "${aws_subnet.customer_private_2.id}", "${aws_subnet.customer_private_2.id}"]
  tags {
    Name = "RDS Subnet"
  }
}
output "rds_id" {
  value = "${aws_db_subnet_group.rds.id}"
}
