# provider.tf

provider "aws" {
  region = var.region
}

# Remote backend configuration (using S3 and DynamoDB for state locking)
terraform {
  backend "s3" {
    bucket         = "mir-terraform-s3-bucket"
    key            = "key/terraform.tfstate"
    region         = var.region
    dynamodb_table = "dynamodb-state-locking"
    encrypt        = true
  }
}
