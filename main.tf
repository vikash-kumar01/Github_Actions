# main.tf

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
  cluster_name    = var.cluster_name
  cluster_version = "1.30"
  subnets         = aws_subnet.private[*].id
  vpc_id          = aws_vpc.main.id
  tags = {
    Name = var.cluster_name
  }
}

# EC2 Bastion Host Configuration
resource "aws_key_pair" "bastion_key" {
  key_name   = "bastion-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "bastion" {
  ami                    = "ami-0aebec83a182ea7ea" # Amazon Linux 2 AMI
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private[0].id
  associate_public_ip_address = true
  key_name               = aws_key_pair.bastion_key.key_name

  tags = {
    Name = "bastion-host"
  }
}
