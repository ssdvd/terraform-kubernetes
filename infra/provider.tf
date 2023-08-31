terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-2"
}

data "aws_eks_cluster" "default" {
  name = var.cluster-nome
}

data "aws_eks_cluster_auth" "default" {
  name = var.cluster-nome
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.default.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.default.token
}