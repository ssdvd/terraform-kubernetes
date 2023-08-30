module "prod" {
  source = "../../infra"

  nome-repo = "prod"
  cargo-iam = "prod"
  ambiente  = "prod"

}

output "ip-alb" {
  value = module.prod.alb-dns
}
