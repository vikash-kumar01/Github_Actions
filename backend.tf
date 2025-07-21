terraform {
  backend "s3" {
    bucket = "cloudwithvikash-terraform-backend"
    key    = "key/terraform.tfstate"
    region = "ap-south-1"
  }
}