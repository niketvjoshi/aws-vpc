resource "aws_vpc" "vpc_01" {
  cidr_block                    = "${var.vpc_01_cidr_block}"
  instance_tenancy              = "default"
  
  tags = {
    environment                 = "production"
    business_unit               = "nj87"
    it_owner                    = "niket.joshi@hotmail.com"
    type                        = "vpc"
    project                     = "nj87"
  }
}

resource "aws_subnet" "subnet_01" {
  vpc_id                        = aws_vpc.vpc_01.id
  cidr_block                    = "${var.subnet_01_cidr_block}"
  map_public_ip_on_launch       = true

  tags = {
    environment                 = "production"
    business_unit               = "nj87"
    it_owner                    = "niket.joshi@hotmail.com"
    type                        = "vpc"
    project                     = "nj87"
  } 
}

resource "aws_subnet" "subnet_02" {
  vpc_id                        = aws_vpc.vpc_01.id
  cidr_block                    = "${var.subnet_02_cidr_block}"

  tags = {
    environment                 = "production"
    business_unit               = "nj87"
    it_owner                    = "niket.joshi@hotmail.com"
    type                        = "vpc"
    project                     = "nj87"
  } 
}

resource "aws_internet_gateway" "igw" {
  vpc_id                        = aws_vpc.vpc_01.id

  tags = {
    environment                 = "production"
    business_unit               = "nj87"
    it_owner                    = "niket.joshi@hotmail.com"
    type                        = "vpc"
    project                     = "nj87"
  }
}

resource "aws_route_table" "public" {
  vpc_id                        = aws_vpc.vpc_01.id

  tags = {
    environment                 = "production"
    business_unit               = "nj87"
    it_owner                    = "niket.joshi@hotmail.com"
    type                        = "vpc"
    project                     = "nj87"
  } 
}

resource "aws_route" "public" {
  route_table_id                = aws_route_table.public.id
  destination_cidr_block        = "0.0.0.0/0"
  gateway_id                    = aws_internet_gateway.igw.id

  timeouts {
    create                      = "5m" 
  }  
}

resource "aws_route_table_association" "public" {
  subnet_id                     = aws_subnet.subnet_01.id
  route_table_id                = aws_route_table.public.id  
}

resource "aws_eip" "nat" {  
  vpc                           = true

    tags = {
    environment                 = "production"
    business_unit               = "nj87"
    it_owner                    = "niket.joshi@hotmail.com"
    type                        = "vpc"
    project                     = "nj87"
  } 
}

resource "aws_nat_gateway" "ngw" {
  allocation_id                 = aws_eip.nat.id
  subnet_id                     = aws_subnet.subnet_01.id 

  tags = {
    environment                 = "production"
    business_unit               = "nj87"
    it_owner                    = "niket.joshi@hotmail.com"
    type                        = "vpc"
    project                     = "nj87"
  }

  depends_on = [ "aws_internet_gateway.igw" ]
}

resource "aws_route_table" "private" {
  vpc_id                        = aws_vpc.vpc_01.id

  tags = {
    environment                 = "production"
    business_unit               = "nj87"
    it_owner                    = "niket.joshi@hotmail.com"
    type                        = "vpc"
    project                     = "nj87"
  } 
}

resource "aws_route" "private" {
  route_table_id                = aws_route_table.private.id
  destination_cidr_block        = "0.0.0.0/0"
  nat_gateway_id                = aws_nat_gateway.ngw.id 

  timeouts {
    create                      = "5m" 
  }  
}

resource "aws_route_table_association" "private" {
  subnet_id                     = aws_subnet.subnet_02.id
  route_table_id                = aws_route_table.private.id
}






