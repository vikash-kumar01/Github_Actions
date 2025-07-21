locals {
  environment = path_relative_to_include()
}

remote_state {
  backend = "s3"
  config = {
    bucket         = "backend-${local.environment}-infra"
    key            = "${local.environment}/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-${local.environment}"
    encrypt        = true
  }
}
