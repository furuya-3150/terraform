# security_group
resource "aws_security_group" "web-sg" {
  name        = "${var.project}-${var.environment}-web-sg"
  description = "web-sg"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-web-sg"
    project = var.project
    Env     = var.environment
  }
}

resource "aws_security_group_rule" "web-in-tcp" {
  security_group_id = aws_security_group.web-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "web-in-https" {
  security_group_id = aws_security_group.web-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "web-out-tpc" {
  security_group_id        = aws_security_group.web-sg.id
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = 3000
  to_port                  = 3000
  source_security_group_id = aws_security_group.app-sg.id
}

resource "aws_security_group" "app-sg" {
  name        = "${var.project}-${var.environment}-app-sg"
  description = "app-sg"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-app-sg"
    project = var.project
    Env     = var.environment
  }
}

resource "aws_security_group_rule" "app-in-tcp" {
  security_group_id        = aws_security_group.app-sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 3000
  to_port                  = 3000
  source_security_group_id = aws_security_group.web-sg.id
}

resource "aws_security_group_rule" "app-out-http" {
  security_group_id = aws_security_group.app-sg.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  prefix_list_ids   = [data.aws_prefix_list.s3_pl.id]
}

resource "aws_security_group_rule" "app-out-https" {
  security_group_id = aws_security_group.app-sg.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  prefix_list_ids   = [data.aws_prefix_list.s3_pl.id]
}

resource "aws_security_group_rule" "app-out-tpc" {
  security_group_id        = aws_security_group.app-sg.id
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
  source_security_group_id = aws_security_group.db-sg.id
}

resource "aws_security_group" "opmng-sg" {
  name        = "${var.project}-${var.environment}-opmng-sg"
  description = "opmng-sg"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-opmng-sg"
    project = var.project
    Env     = var.environment
  }
}

resource "aws_security_group_rule" "opmng-in-ssh" {
  security_group_id = aws_security_group.opmng-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "opmng-in-tcp" {
  security_group_id = aws_security_group.opmng-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 3000
  to_port           = 3000
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "opmng-out-http" {
  security_group_id = aws_security_group.opmng-sg.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "opmng-out-https" {
  security_group_id = aws_security_group.opmng-sg.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group" "db-sg" {
  name        = "${var.project}-${var.environment}-db-sg"
  description = "db-sg"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-db-sg"
    project = var.project
    Env     = var.environment
  }
}

resource "aws_security_group_rule" "db-in-tcp" {
  security_group_id        = aws_security_group.db-sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
  source_security_group_id = aws_security_group.app-sg.id
}
