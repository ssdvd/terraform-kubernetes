resource "aws_security_group" "ssh-cluster" {
  name   = "ssh-cluster"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "ssh-cluster-in" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ssh-cluster.id
}

resource "aws_security_group_rule" "ssh-cluster-out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ssh-cluster.id
}

resource "aws_security_group" "privado" {
  name   = "privado-ecs"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "entrada-ecs" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.ssh-cluster.id
  security_group_id        = aws_security_group.privado.id
}

resource "aws_security_group_rule" "saida-ecs" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.privado.id
}
