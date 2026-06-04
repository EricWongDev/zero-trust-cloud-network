resource "aws_security_group" "hub_firewall_sg" {
  name        = "zero-trust-hub-firewall"
  description = "Centralized Stateful Inspection Boundary"
  vpc_id      = module.hub_vpc.vpc_id

  # Ingress Rule 1: Allow SSH only from YOUR computer (for management)
  # NOTE: 0.0.0.0/0 is used here temporarily for ease of initial connection. 
  # In a strict environment, this is replaced by your specific home IP address.
  ingress {
    description = "Allow Admin SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Ingress Rule 2: Allow internal ICMP (Ping) from the Spoke VPCs for testing connectivity
  ingress {
    description = "Allow ICMP from Spoke Networks"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.1.0.0/16", "10.2.0.0/16"]
  }

  # Egress Rule: Allow the Hub to reach the internet to fetch updates/packages
  egress {
    description = "Allow Egress to Internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Hub-Firewall-Policy"
  }
}