terraform {
  backend "s3" {
    bucket = "cloudwithvikash-terraform-backend"
    key    = "githubactionskey/terraform.tfstate"
    region = "us-east-1"
  }
}