# provider.tf

provider "aws" {
  region = "ap-south-1"
}

# Remote backend configuration (using S3 and DynamoDB for state locking)
terraform {
  backend "s3" {
    bucket         = "mir-terraform-s3-bucket"
    key            = "key/terraform.tfstate"
    region         = "ap-south-1"        
  }
}
