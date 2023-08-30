module "prod" {
  source = "../../infra"

  nome-repo = "prod"
  cargo-iam = "prod"
  ambiente  = "prod"
  cluster-nome = "prod"
}

output "ip-alb" {
  value = module.prod.alb-dns
}
