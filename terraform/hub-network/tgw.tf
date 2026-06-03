# 1. Create the Transit Gateway (The Central Router)
resource "aws_ec2_transit_gateway" "main_tgw" {
  description                     = "Zero-Trust Transit Gateway"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  
  tags = {
    Name = "Main-Transit-Gateway"
  }
}

# 2. Plug the Hub VPC into the Transit Gateway
resource "aws_ec2_transit_gateway_vpc_attachment" "hub_attachment" {
  subnet_ids         = module.hub_vpc.private_subnets
  transit_gateway_id = aws_ec2_transit_gateway.main_tgw.id
  vpc_id             = module.hub_vpc.vpc_id
  
  tags = {
    Name = "Hub-VPC-Attachment"
  }
}

# 3. Plug the Prod Spoke VPC into the Transit Gateway
resource "aws_ec2_transit_gateway_vpc_attachment" "prod_attachment" {
  subnet_ids         = module.prod_spoke_vpc.private_subnets
  transit_gateway_id = aws_ec2_transit_gateway.main_tgw.id
  vpc_id             = module.prod_spoke_vpc.vpc_id
  
  tags = {
    Name = "Prod-Spoke-Attachment"
  }
}

# 4. Plug the Dev Spoke VPC into the Transit Gateway
resource "aws_ec2_transit_gateway_vpc_attachment" "dev_attachment" {
  subnet_ids         = module.dev_spoke_vpc.private_subnets
  transit_gateway_id = aws_ec2_transit_gateway.main_tgw.id
  vpc_id             = module.dev_spoke_vpc.vpc_id
  
  tags = {
    Name = "Dev-Spoke-Attachment"
  }
}