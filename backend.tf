terraform {
  backend "s3" {
    bucket         = "fiap-x-storage"
    key            = "terraform/state/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}
