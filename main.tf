##########################################################################
#VPC
##########################################################################

resource "aws_vpc" "myprac-vpc" {
  cidr_block           = var.cidr_block_vpc
  instance_tenancy     = "default"
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  tags = {
    Name        = "myprac-vpc"
    Environment = "prod"
  }
}

##########################################################################
#VPC- FLOW LOGS
##########################################################################

/* resource "aws_flow_log" "myprac-vpc-flow-logs" {
  iam_role_arn    = aws_iam_role.flow-log-role.arn
  log_destination = aws_cloudwatch_log_group.mycloudwatch.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.myprac-vpc.id
}

resource "aws_cloudwatch_log_group" "mycloudwatch" {
  name = "mycloudwatch"
}


resource "aws_iam_role" "flow-log-role" {
  name = "flow-log-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "flow-logs-policy" {
  name = "flow-logs-policy"
  role = aws_iam_role.flow-log-role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

 */

resource "aws_flow_log" "myprac-vpc-flow-logs1" {
  log_destination      = aws_s3_bucket.mydev-ossing-ta.arn
  log_destination_type = var.log_destination_type
  traffic_type         = var.traffic_type
  vpc_id               = aws_vpc.myprac-vpc.id
}


resource "aws_s3_bucket" "mydev-ossing-ta" {
  bucket = var.bucket
  tags = {
    Name        = "mydev-ossing-ta"
    Environment = "prod"
  }
}


resource "aws_s3_bucket_acl" "mydev_bucket_acl" {
  bucket = aws_s3_bucket.mydev-ossing-ta.id
  acl    = var.acl
}


##########################################################################
#IGW
##########################################################################

resource "aws_internet_gateway" "myprac-vpc-igw" {
  vpc_id = aws_vpc.myprac-vpc.id
  tags = {
    Name        = "myprac-vpc-igw"
    Environment = "prod"
  }
}


resource "aws_internet_gateway_attachment" "myprac-vpc-igw-att" {
  internet_gateway_id = aws_internet_gateway.myprac-vpc-igw.id
  vpc_id              = aws_vpc.myprac-vpc.id
}


##########################################################################
#PUB SUBNET
##########################################################################


resource "aws_subnet" "myprac-sub-pub1" {
  vpc_id            = aws_vpc.myprac-vpc.id
  cidr_block        = var.cidr_block_pub1
  availability_zone = var.az-use1a
  tags = {
    Name        = "myprac-sub-pub1"
    Environment = "prod"
  }
}


resource "aws_subnet" "myprac-sub-pub2" {
  vpc_id            = aws_vpc.myprac-vpc.id
  cidr_block        = var.cidr_block_pub2
  availability_zone = var.az-use1b
  tags = {
    Name        = "myprac-sub-pub2"
    Environment = "prod"
  }
}

##########################################################################
#PRIVATE SUBNET
##########################################################################

resource "aws_subnet" "myprac-sub-pri1" {
  vpc_id            = aws_vpc.myprac-vpc.id
  cidr_block        = var.cidr_block_pri1
  availability_zone = var.az-use1a
  tags = {
    Name        = "myprac-sub-pri1"
    Environment = "prod"
  }
}


resource "aws_subnet" "myprac-sub-pri2" {
  vpc_id            = aws_vpc.myprac-vpc.id
  cidr_block        = var.cidr_block_pri2
  availability_zone = var.az-use1b
  tags = {
    Name        = "myprac-sub-pri2"
    Environment = "prod"
  }
}


resource "aws_subnet" "myprac-sub-pri3" {
  vpc_id            = aws_vpc.myprac-vpc.id
  cidr_block        = var.cidr_block_pri3
  availability_zone = var.az-use1a
  tags = {
    Name        = "myprac-sub-pri3"
    Environment = "prod"
  }
}


resource "aws_subnet" "myprac-sub-pri4" {
  vpc_id            = aws_vpc.myprac-vpc.id
  cidr_block        = var.cidr_block_pri4
  availability_zone = var.az-use1b
  tags = {
    Name        = "myprac-sub-pri4"
    Environment = "prod"
  }
}

##########################################################################
#PUBLIC RT AND ROUTE 
##########################################################################

resource "aws_route_table" "myprac-pubrt" {
  vpc_id = aws_vpc.myprac-vpc.id
  tags = {
    Name        = "myprac-pubrt"
    Environment = "prod"
  }
}


resource "aws_route" "pub_route" {
  route_table_id         = aws_route_table.myprac-pubrt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.myprac-vpc-igw.id
  depends_on             = [aws_route_table.myprac-pubrt]
}



##########################################################################
#PUB-SUBNET ASSOCIATION
##########################################################################

resource "aws_route_table_association" "pub1-rt-ass" {
  subnet_id      = aws_subnet.myprac-sub-pub1.id
  route_table_id = aws_route_table.myprac-pubrt.id
}


resource "aws_route_table_association" "pub2-rt-ass" {
  subnet_id      = aws_subnet.myprac-sub-pub2.id
  route_table_id = aws_route_table.myprac-pubrt.id
}




##########################################################################
#PRIVATE RT 
##########################################################################
resource "aws_route_table" "myprac-prirt1" {
  vpc_id = aws_vpc.myprac-vpc.id
  tags = {
    Name        = "myprac-prirt1"
    Environment = "prod"
  }
}


##########################################################################
#PRIVATE RT ASSOCIATION
##########################################################################
resource "aws_route_table_association" "pri1-rt-ass" {
  subnet_id      = aws_subnet.myprac-sub-pri1.id
  route_table_id = aws_route_table.myprac-prirt1.id
}


resource "aws_route_table_association" "pri2-rt-ass" {
  subnet_id      = aws_subnet.myprac-sub-pri2.id
  route_table_id = aws_route_table.myprac-prirt1.id
}


resource "aws_route_table_association" "pri3-rt-ass" {
  subnet_id      = aws_subnet.myprac-sub-pri3.id
  route_table_id = aws_route_table.myprac-prirt1.id
}


resource "aws_route_table_association" "pri4-rt-ass" {
  subnet_id      = aws_subnet.myprac-sub-pri4.id
  route_table_id = aws_route_table.myprac-prirt1.id
}



##########################################################################
#EIP
##########################################################################
resource "aws_eip" "myprac-eip" {
  vpc = true
}

resource "aws_eip" "myprac-eip1" {
  vpc = true
}


##########################################################################
#NATGW
##########################################################################

resource "aws_nat_gateway" "mynat1" {
  allocation_id = aws_eip.myprac-eip.id
  subnet_id     = aws_subnet.myprac-sub-pub1.id
  tags = {
    Name = "mynat1"
  }
  depends_on = [aws_internet_gateway.myprac-vpc-igw]
}



resource "aws_nat_gateway" "mynat2" {
  allocation_id = aws_eip.myprac-eip1.id
  subnet_id     = aws_subnet.myprac-sub-pub2.id
  tags = {
    Name = "mynat2"
  }
  depends_on = [aws_internet_gateway.myprac-vpc-igw]
}

##########################################################################
#PRIVATE ROUTE
##########################################################################


resource "aws_route" "pri_route1" {
  route_table_id         = aws_route_table.myprac-prirt1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.mynat1.id
  depends_on             = [aws_route_table.myprac-prirt1]
}


resource "aws_route" "pri_route2" {
  route_table_id         = aws_route_table.myprac-prirt1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.mynat2.id
  depends_on             = [aws_route_table.myprac-prirt1]
}


resource "aws_instance" "webserver1" {
  count = 2
  ami           = var.web-ami
  instance_type = var.web-instance_type
  associate_public_ip_address = var. associate_public_ip_address
  availability_zone = var.az-use1a
  key_name = "landmarkkey"
  subnet_id = aws_subnet.myprac-sub-pub1.id
  tags={
    Name = "webserver1"
    Environment = "prod"
  }

}


resource "aws_instance" "webserver2" {
  count = 2
  ami           = var.web-ami
  instance_type = var.web-instance_type
  associate_public_ip_address = var. associate_public_ip_address
  availability_zone = var.az-use1b
  key_name = "landmarkkey"
  subnet_id = aws_subnet.myprac-sub-pub2.id
  tags={
    Name = "webserver2"
    Environment = "prod"
  }

}




