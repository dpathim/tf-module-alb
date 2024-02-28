resource "aws_lb" "main" {
  name               ="${var.env}-dev"
  internal           = var.internal
  load_balancer_type = var.lb_type
  security_groups    = [aws_security_group.main.id]
  subnets            = var.subnets

  tags = merge(local.tags, {Name = "${var.env}-alb"})
}

resource "aws_security_group" "main" {
  name        = local.sg_name
  description = local.sg_name
  vpc_id      = var.vpc_id
  tags = merge(local.tags, {Name = local.sg_name})


}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  description = "APP"
  security_group_id   = aws_security_group.main.id
  cidr_ipv4         = var.sg_ingress_cidr
  from_port         = var.sg_port
  ip_protocol       = "tcp"
  to_port           = var.sg_port
}
resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv6" {
  security_group_id = aws_security_group.main.id
  from_port         = var.sg_port
  ip_protocol       = "tcp"
  to_port           = var.sg_port
}



resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id   = aws_security_group.main.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id   = aws_security_group.main.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}