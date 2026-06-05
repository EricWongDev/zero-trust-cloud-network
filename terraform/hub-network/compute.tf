# 1. Upload your Public SSH Key to AWS
resource "aws_key_pair" "bastion_key" {
  key_name   = "zero-trust-bastion-key"
  public_key = file("${path.module}/my-bastion-key.pub")
}

# 2. Find the latest Ubuntu Linux image in AWS
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (Ubuntu's parent company)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# 3. Build the Bastion Host EC2 Instance
resource "aws_instance" "bastion" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro" # Free-tier eligible

  # Put it in the first Public Subnet of the Hub VPC
  subnet_id                   = module.hub_vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.hub_firewall_sg.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.bastion_key.key_name

  tags = {
    Name = "Hub-Bastion-Host"
    Role = "Ansible-Target"
  }
}

# 4. Print the Public IP address to the screen when finished
output "bastion_public_ip" {
  description = "The public IP of the Bastion Host"
  value       = aws_instance.bastion.public_ip
}