include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../modules/ec2"
}

inputs = {
  aws_region     = "us-east-1"
  vpc_cidr       = "10.0.0.0/16"
  subnet_1_cidr  = "10.0.1.0/24"
  subnet_2_cidr  = "10.0.2.0/24"
  subnet_3_cidr  = "10.0.3.0/24"
  az1            = "us-east-1a"
  az2            = "us-east-1b"
  az3            = "us-east-1c"
  ami_id         = "ami-0f58c7d8cda0a0e20"
  instance_type  = "t2.micro"
  key_name       = "mrdevops"
}
