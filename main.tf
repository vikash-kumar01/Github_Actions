# main.tf file

# Retrieve available availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# VPC Configuration
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "my-eks-vpc"
  }
}

# Create Private Subnets
resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index}.0/24"
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = false
  tags = {
    Name = "my-private-subnet-${count.index}"
  }
}

# Create Internet Gateway for NAT Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "my-eks-igw"
  }
}

# Create EKS Cluster
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = ">= 18.0.0" # Adjust version if necessary
  cluster_name    = var.cluster_name
  cluster_version = "1.30"
  vpc_id          = aws_vpc.main.id
  subnet_ids      = aws_subnet.private[*].id  # Use 'subnet_ids'
  tags = {
    Name = var.cluster_name
  }
}

# Generate SSH Key Pair if not exists
resource "tls_private_key" "bastion_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# EC2 Bastion Host Configuration
resource "aws_key_pair" "bastion_key" {
  key_name   = "bastion-key"
  public_key = tls_private_key.bastion_key.public_key_openssh
}

resource "aws_instance" "bastion" {
  ami                    = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.private[0].id
  associate_public_ip_address = true
  key_name               = aws_key_pair.bastion_key.key_name

  tags = {
    Name = "bastion-host"
  }
}

resource "aws_security_group_rule" "example" {
  security_group_id = aws_security_group.example.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]

  lifecycle {
    ignore_changes = [cidr_blocks]  # Ignore changes if you know they already exist
  }
}
