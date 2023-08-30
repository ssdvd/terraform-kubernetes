terraform {
  backend "s3" {
    bucket = "terraform-docker-ecr-ssdvd"
    key    = "prod/terraform.tfstate"
    region = "us-east-2"
  }
}