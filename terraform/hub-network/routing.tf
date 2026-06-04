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