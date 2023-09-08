resource "aws_vpc" "main" {
  cidr_block = var.cidr["vpc"]
  tags = {
    Name = "${var.network_prefix}-vpc"
  }
}


resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidr["sub_pub"]
  map_public_ip_on_launch = true
  availability_zone = "${var.region}a"

  tags = {
    Name = "${var.network_prefix}-public"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidr["sub_pub_2"]
  map_public_ip_on_launch = true
  availability_zone = "${var.region}b"

  tags = {
    Name = "${var.network_prefix}-public-2"
  }
}


resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidr["sub_priv"]

  tags = {
    Name = "${var.network_prefix}-private"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.network_prefix}-igw"
  }
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.network_prefix}-public-rt"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route = []

  tags = {
    Name = "${var.network_prefix}-private-rt"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id       = aws_subnet.public.id
  route_table_id  = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  subnet_id       = aws_subnet.private.id
  route_table_id  = aws_route_table.private.id
}