resource "aws_lb" "main" {
  name               ="${var.env}-dev"
  internal           = var.internal
  load_balancer_type = var.lb_type
  security_groups    = [aws_security_group.main.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]

  enable_deletion_protection = true

  access_logs {
    bucket  = aws_s3_bucket.lb_logs.id
    prefix  = "test-lb"
    enabled = true
  }

  tags = {
    Environment = "production"
  }
}

resource "aws_security_group" "main" {
  name        = "${var.env}-alb-sg"
  description = "${var.env}-alb-sg"
  vpc_id      = var.vpc_id
  tags = merge(local.tags, {Name = "${var.env}-alb-sg"})


}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  description = "APP"
  cidr_ipv4         = var.sg_ingress_cidr
  from_port         = var.sg_port
  ip_protocol       = "tcp"
  to_port           = var.sg_port
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}