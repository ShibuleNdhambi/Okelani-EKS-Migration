# Create a new VPC
resource "aws_vpc" "my_vpc" {
    cidr_block       = "10.0.0.0/16"
    instance_tenancy = "default"

    tags = merge({Name = "okelani-vpc"},var.vpc_tags)
}

# Create public subnet
resource "aws_subnet" "public_subnet" {
    vpc_id                  = aws_vpc.my_vpc.id
    cidr_block              = "10.0.1.0/24"
    availability_zone       = "af-south-1a"
    map_public_ip_on_launch = true
    tags = merge({ Name = "Public Subnet 1"}, var.vpc_tags)
}

resource "aws_subnet" "public_subnet_2" {
    vpc_id                  = aws_vpc.my_vpc.id
    cidr_block              = "10.0.2.0/24"
    availability_zone       = "af-south-1b" 
    map_public_ip_on_launch = true
    tags = merge({ Name = "Public Subnet 2"}, var.vpc_tags)
}

resource "aws_subnet" "public_subnet_3" {
    vpc_id                  = aws_vpc.my_vpc.id
    cidr_block              = "10.0.3.0/24"
    availability_zone       = "af-south-1c" 
    map_public_ip_on_launch = true
    tags = merge({ Name = "Public Subnet 1"}, var.vpc_tags)
    
}

# Create private subnet
resource "aws_subnet" "private_subnet" {
    vpc_id                  = aws_vpc.my_vpc.id
    availability_zone       = "af-south-1a"
    cidr_block              = "10.0.128.0/24"
    map_public_ip_on_launch = false
    tags = merge({ Name = "Private Subnet 1"}, var.vpc_tags)
}

resource "aws_subnet" "private_subnet2" {
    vpc_id                  = aws_vpc.my_vpc.id
    availability_zone       = "af-south-1b"
    cidr_block              = "10.0.192.0/24"
    map_public_ip_on_launch = false
    tags = merge({ Name = "Private Subnet 2"}, var.vpc_tags)
}

resource "aws_subnet" "private_subnet3" {
    vpc_id                  = aws_vpc.my_vpc.id
    availability_zone       = "af-south-1c"
    cidr_block              = "10.0.224.0/24"
    map_public_ip_on_launch = false
    tags = merge({ Name = "Private Subnet 3"}, var.vpc_tags)
}


# Create internet gateway
resource "aws_internet_gateway" "my_igw" {
    vpc_id = aws_vpc.my_vpc.id
    tags = merge({Name = "okelani-igw"},var.vpc_tags)
}

# Create route table for public subnet
resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.my_vpc.id
    tags = merge({Name = "okelani-route-table"},var.vpc_tags)
}

# Associate public subnet with public route table
resource "aws_route_table_association" "public_subnet1_association" {
    subnet_id      = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet2_association" {
    subnet_id      = aws_subnet.public_subnet_2.id
    route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet3_association" {
    subnet_id      = aws_subnet.public_subnet_3.id
    route_table_id = aws_route_table.public_route_table.id
}


# Create default route for public subnet
resource "aws_route" "public_route" {
    route_table_id         = aws_route_table.public_route_table.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = aws_internet_gateway.my_igw.id

}


resource "aws_eip" "my_eip" {
  domain = "vpc"
  tags = merge({Name = "okelani-eip"},var.vpc_tags)
}

# Create NAT gateway for private subnet
resource "aws_nat_gateway" "my_nat_gateway" {
    allocation_id = aws_eip.my_eip.id
    subnet_id     = aws_subnet.private_subnet.id
    tags = merge({Name = "okelani-nat-gateway"},var.vpc_tags)
}


resource "aws_security_group" "vpc_rule" {
    name        = "vpc_rule"
    description = "Allow all traffic from VPC"
    vpc_id      = aws_vpc.my_vpc.id

    ingress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = merge({Name = "okelani-vpc-SG"},var.vpc_tags)

}