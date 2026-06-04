# Production Spoke VPC - Strictly Private
module "prod_spoke_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "prod-spoke-vpc"
  cidr = "10.1.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.1.1.0/24", "10.1.2.0/24"]

  # No public internet access directly from this VPC
  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Environment = "Production"
    Project     = "Zero-Trust-Spoke"
  }
}

# Development Spoke VPC - Strictly Private
module "dev_spoke_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "dev-spoke-vpc"
  cidr = "10.2.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.2.1.0/24", "10.2.2.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Environment = "Development"
    Project     = "Zero-Trust-Spoke"
  }
}