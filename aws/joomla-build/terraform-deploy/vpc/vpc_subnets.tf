resource "aws_vpc" "stage_vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = "true"
}

resource "aws_internet_gateway" "stage_igw" {
  vpc_id = "${aws_vpc.stage_vpc.id}"
  tags {
    Name = "stage_test_igw"
  }
}

output "customer_vpc_id" {
  value = "${aws_vpc.stage_vpc.id}"
}

##
## UAT route tables and subnet group
##

resource "aws_subnet" "uat_public_1" {
  vpc_id                  = "${aws_vpc.stage_vpc.id}"
  cidr_block              = "${var.public_snet_cidr}"
  map_public_ip_on_launch = "true"
  availability_zone       = "${var.region}a"
  tags {
    Name = "Subnet 2a"
  }
}
output "uat_public_1_id" {
  value = "${aws_subnet.uat_public_1.id}"
}

resource "aws_route_table" "uat_public_1" {
  vpc_id = "${aws_vpc.stage_vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.stage_igw.id}"
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
  vpc_id                  = "${aws_vpc.stage_vpc.id}"
  cidr_block              = "${var.public_snet_2_cidr}"
  map_public_ip_on_launch = "true"
  availability_zone       = "${var.region}b"
  tags {
    Name = "Subnet 2a"
  }
}
output "uat_public_2" {
  value = "${aws_subnet.uat_public_2.id}"
}

resource "aws_route_table" "uat_public_2" {
  vpc_id = "${aws_vpc.stage_vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.stage_igw.id}"
  }
  tags {
    Name = "uat_subnet_2_route_table"
  }
}

resource "aws_route_table_association" "uat_public_2" {
  subnet_id      = "${aws_subnet.uat_public_2.id}"
  route_table_id = "${aws_route_table.uat_public_2.id}"
}
