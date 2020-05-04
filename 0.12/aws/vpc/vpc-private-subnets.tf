# Create private subnet withing VPC for each defined Availability Zone and CIDR
locals {
  private_subnets = flatten([
    for az_name in keys(var.vpc_availability_zones) : [
      for cidr in lookup(var.vpc_availability_zones, az_name).private_subnets_cidr : [
        {
          az_name = az_name
          cidr    = cidr
          az      = lookup(var.vpc_availability_zones, az_name)
        }
      ]
    ]
  ])
}
resource "aws_subnet" "private" {
  count             = length(local.private_subnets)
  vpc_id            = aws_vpc.main.id
  availability_zone = local.private_subnets[count.index].az_name
  cidr_block        = local.private_subnets[count.index].cidr
  tags              = merge({ Name = "${var.vpc_name}-${local.private_subnets[count.index].az_name}-private${index(local.private_subnets[count.index].az.private_subnets_cidr, local.private_subnets[count.index].cidr)}" }, var.tags, local.private_subnets[count.index].az.tags)
  lifecycle {
    ignore_changes = [
      # Ignore changes to tags, e.g. because eks adds bunch of tags
      tags,
    ]
  }
  depends_on = [aws_vpc.main, var.vpc_availability_zones]
}

# Create custom route table within VPC for each defined availability zone and add routing to NAT Gateway
resource "aws_route_table" "private_routes" {
  count    = length(aws_subnet.public)
  vpc_id   = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gateway[count.index].id
  }
  tags       = merge({ Name = "${var.vpc_name}-${aws_subnet.public[count.index].availability_zone}-private-route" }, var.tags, lookup(var.vpc_availability_zones, aws_subnet.public[count.index].availability_zone).tags)
  depends_on = [aws_nat_gateway.nat-gateway, aws_subnet.private]
}

# Associate each private route table with private subnets
locals {
  let start = 0
  azs_to_private_route = {
    while start < length(aws_subnet.public) :
      aws_subnet.public[start].availability_zone => aws_route_table.private_routes[start]
      start = start + 1
  }
}

resource "aws_route_table_association" "private_route_association" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = lookup(local.azs_to_private_route, aws_subnet.private[count.index].availability_zone).id
  depends_on     = [aws_route_table.private_routes]
}
