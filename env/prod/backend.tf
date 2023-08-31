terraform {
  backend "s3" {
    bucket = "terraform-kubernetes-ssdvd"
    key    = "prod/terraform.tfstate"
    region = "us-east-2"
  }
}