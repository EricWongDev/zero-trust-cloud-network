# 1. Force Prod Spoke traffic to the Transit Gateway
resource "aws_route" "prod_to_tgw" {
  count                  = length(module.prod_spoke_vpc.private_route_table_ids)
  route_table_id         = module.prod_spoke_vpc.private_route_table_ids[count.index]
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = aws_ec2_transit_gateway.main_tgw.id
}

# 2. Force Dev Spoke traffic to the Transit Gateway
resource "aws_route" "dev_to_tgw" {
  count                  = length(module.dev_spoke_vpc.private_route_table_ids)
  route_table_id         = module.dev_spoke_vpc.private_route_table_ids[count.index]
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = aws_ec2_transit_gateway.main_tgw.id
}

# 3. Tell the Transit Gateway to send all unknown traffic to the Hub VPC
resource "aws_ec2_transit_gateway_route" "default_to_hub" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_route_table_id = aws_ec2_transit_gateway.main_tgw.association_default_route_table_id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.hub_attachment.id
}


# Create a combined list of all Hub route tables (Public and Private)
locals {
  hub_route_tables = concat(module.hub_vpc.public_route_table_ids, module.hub_vpc.private_route_table_ids)
}

# Return route: Hub VPC back to Prod Spoke
resource "aws_route" "hub_to_prod_spoke" {
  count                  = length(local.hub_route_tables)
  route_table_id         = local.hub_route_tables[count.index]
  destination_cidr_block = "10.1.0.0/16"
  transit_gateway_id     = aws_ec2_transit_gateway.main_tgw.id
}

# Return route: Hub VPC back to Dev Spoke
resource "aws_route" "hub_to_dev_spoke" {
  count                  = length(local.hub_route_tables)
  route_table_id         = local.hub_route_tables[count.index]
  destination_cidr_block = "10.2.0.0/16"
  transit_gateway_id     = aws_ec2_transit_gateway.main_tgw.id
}