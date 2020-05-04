# Create subnet subnet withing VPC for each defined Availability Zone and CIDR
locals {
  public_subnets = flatten([
    for az_name in keys(var.vpc_availability_zones) : [
      for cidr in lookup(var.vpc_availability_zones, az_name).public_subnets_cidr : [
        {
          az_name = az_name
          cidr    = cidr
          az      = lookup(var.vpc_availability_zones, az_name)
        }
      ]
    ]
  ])
}

# Create public subnet in VPC for each defined Availability Zone
resource "aws_subnet" "public" {
  count             = length(local.public_subnets)
  vpc_id            = aws_vpc.main.id
  availability_zone = local.public_subnets[count.index].az_name
  cidr_block        = local.public_subnets[count.index].cidr
  tags              = merge({ Name = "${var.vpc_name}-${local.public_subnets[count.index].az_name}-public${index(local.public_subnets[count.index].az.public_subnets_cidr, local.public_subnets[count.index].cidr)}" }, var.tags, local.public_subnets[count.index].az.tags)
  map_public_ip_on_launch = true
  lifecycle {
    ignore_changes = [
      # Ignore changes to tags, e.g. because eks adds bunch of tags
      tags,
    ]
  }

  depends_on = [aws_vpc.main, var.vpc_availability_zones]
}

# Associate public subnet with VPC main route table
resource "aws_route_table_association" "public-subnet-to-main" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index]
  route_table_id = aws_route_table.main.id
  depends_on     = [aws_route_table.main]
}

# Create EIP's for ech public subnet to assing to NAT Gateway
resource "aws_eip" "eips" {
  count      = length(aws_subnet.public)
  vpc        = true
  tags       = merge({ Name = "${var.vpc_name}" }, var.tags, var.vpc_tags)
  depends_on = [aws_internet_gateway.main]
}

# Create NAT Gateway
resource "aws_nat_gateway" "nat-gateway" {
  count         = length(aws_subnet.public)
  allocation_id = aws_eip.eips[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  tags          = merge({ Name = "${var.vpc_name}-${aws_subnet.public[count.index].availability_zone}-nat" }, var.tags)
  depends_on    = [aws_internet_gateway.main, aws_subnet.public, aws_eip.eips]
}
