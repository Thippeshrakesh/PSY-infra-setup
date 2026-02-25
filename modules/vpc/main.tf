############################################
# VPC
############################################

resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr

  tags = merge(var.common_tags, {
    Name = var.vpc_name
  })
}

############################################
# Internet Gateway
############################################

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.common_tags, {
    Name = "${var.vpc_name}-igw"
  })
}

############################################
# Public Subnets (2)
############################################

resource "aws_subnet" "public" {
  count = 2

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.common_tags, {
    Name = "${var.vpc_name}-public-${count.index + 1}"
  })
}

############################################
# Private Subnets (2)
############################################

resource "aws_subnet" "private" {
  count = 2

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(var.common_tags, {
    Name = "${var.vpc_name}-private-${count.index + 1}"
  })
}

############################################
# DB Subnets (2) - Required for RDS Multi-AZ
############################################

resource "aws_subnet" "db" {
  count = 2

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.db_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(var.common_tags, {
    Name = "${var.vpc_name}-db-${count.index + 1}"
  })
}

############################################
# Elastic IP for NAT
############################################

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = merge(var.common_tags, {
    Name = "${var.vpc_name}-nat-eip"
  })
}

############################################
# NAT Gateway (ONLY 1)
############################################

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id   # NAT in first public subnet

  tags = merge(var.common_tags, {
    Name = "${var.vpc_name}-nat"
  })

  depends_on = [aws_internet_gateway.this]
}

############################################
# Public Route Table
############################################

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(var.common_tags, {
    Name = "${var.vpc_name}-public-rt"
  })
}

resource "aws_route_table_association" "public" {
  count = 2

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

############################################
# Private Route Table (Single NAT for both AZs)
############################################

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }

  tags = merge(var.common_tags, {
    Name = "${var.vpc_name}-private-rt"
  })
}

resource "aws_route_table_association" "private" {
  count = 2

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

############################################
# DB Route Table (No Internet Access)
############################################

resource "aws_route_table" "db" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.common_tags, {
    Name = "${var.vpc_name}-db-rt"
  })
}

resource "aws_route_table_association" "db" {
  count = 2

  subnet_id      = aws_subnet.db[count.index].id
  route_table_id = aws_route_table.db.id
}