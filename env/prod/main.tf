module "prod" {
  source = "../../infra"

  nome-repo = "prod"
  cluster-nome = "prod"
}

output "url-lb" {
  value = module.prod.url-lb
}