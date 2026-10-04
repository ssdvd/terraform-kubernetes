# terraform-kubernetes

Infraestrutura como código para rodar uma API Django no Kubernetes: o Terraform cria o cluster no Amazon EKS e também publica o deployment e o service da aplicação pelo provider do Kubernetes.

Projeto do curso **Infraestrutura como código: Terraform e Kubernetes**, da Alura.

## Arquitetura

```
              ┌──────────────────────────┐
usuários ───► │ Service (LoadBalancer)   │ :8000
              └────────────┬─────────────┘
                           │
              ┌────────────▼─────────────┐
              │ Deployment django-api    │ 3 réplicas
              │ EKS 1.27, nodes t2.micro │ (1 a 10 nodes)
              └──────────────────────────┘
```

| Arquivo | Recursos |
| --- | --- |
| [`infra/vpc.tf`](infra/vpc.tf) | VPC `10.0.0.0/16` com 3 subnets públicas, 3 privadas e NAT Gateway |
| [`infra/eks.tf`](infra/eks.tf) | Cluster EKS 1.27 com managed node group (mínimo 1, desejado 3, máximo 10), pelo módulo `terraform-aws-modules/eks` |
| [`infra/sg.tf`](infra/sg.tf) | Security groups dos nodes |
| [`infra/ecr.tf`](infra/ecr.tf) | Repositório de imagens no ECR |
| [`infra/provider.tf`](infra/provider.tf) | Providers `aws` e `kubernetes`, este autenticado com o token do próprio cluster |
| [`infra/kubernetes.tf`](infra/kubernetes.tf) | Deployment com 3 réplicas, limites de CPU e memória, liveness probe e Service do tipo `LoadBalancer` |
| [`env/prod`](env/prod) | Ambiente de produção: chama o módulo e guarda o state em um bucket S3 |

## Pré-requisitos

- [Terraform](https://developer.hashicorp.com/terraform/install)
- AWS CLI com credenciais no perfil `default`
- `kubectl`, para inspecionar o cluster
- Um bucket S3 para o state remoto (ajuste o nome em [`env/prod/backend.tf`](env/prod/backend.tf))
- A imagem da aplicação em um registry acessível pelo cluster (o endereço está fixo em [`infra/kubernetes.tf`](infra/kubernetes.tf))

## Como usar

```bash
cd env/prod
terraform init
terraform apply
```

O provider do Kubernetes lê os dados do cluster por um `data source`, então o cluster precisa existir antes dos recursos do Kubernetes. Na primeira execução, crie o cluster primeiro e depois o restante:

```bash
terraform apply -target=module.prod.module.eks
terraform apply
```

O output `url-lb` mostra o endereço do Load Balancer; a API responde na porta `8000`. Para acessar o cluster com o `kubectl`:

```bash
aws eks update-kubeconfig --region us-east-2 --name prod
kubectl get pods
```

Para remover tudo, rode `terraform destroy`.

> O EKS, o NAT Gateway e o Load Balancer são cobrados por hora. Destrua o ambiente quando terminar de estudar.

## Projetos relacionados

- [terraform-docker-ecs](https://github.com/ssdvd/terraform-docker-ecs): a mesma API no ECS com Fargate.
- [github-actions-cicd-kubernetes](https://github.com/ssdvd/github-actions-cicd-kubernetes): pipeline de CI/CD entregando no EKS.

As anotações das aulas estão em [`notes/`](notes).
