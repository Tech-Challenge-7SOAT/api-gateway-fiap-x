terraform {
  backend "s3" {
    bucket         = "terraform-deploy-fiapx"
    key            = "apigateway/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}
