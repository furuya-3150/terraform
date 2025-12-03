# key pair

resource "aws_key_pair" "keypair" {
  key_name   = "${var.project}-${var.environment}-keypair"
  public_key = file("./src/tastylog-dev-keypair.pub")

  tags = {
    Name    = "${var.project}-${var.environment}-keypair"
    project = var.project
    Env     = var.environment
  }
}

# parameter store
resource "aws_ssm_parameter" "host" {
  name  = "/${var.project}-${var.environment}/app/MYSQL_HOST"
  type  = "String"
  value = aws_db_instance.mysql_standalone.address
}

resource "aws_ssm_parameter" "port" {
  name  = "/${var.project}-${var.environment}/app/MYSQL_PORT"
  type  = "String"
  value = aws_db_instance.mysql_standalone.port
}

resource "aws_ssm_parameter" "database" {
  name  = "/${var.project}-${var.environment}/app/MYSQL_DATABASE"
  type  = "String"
  value = aws_db_instance.mysql_standalone.db_name
}

resource "aws_ssm_parameter" "username" {
  name  = "/${var.project}-${var.environment}/app/MYSQL_USERNAME"
  type  = "String"
  value = aws_db_instance.mysql_standalone.username
}

resource "aws_ssm_parameter" "password" {
  name  = "/${var.project}-${var.environment}/app/MYSQL_PASSWORD"
  type  = "String"
  value = aws_db_instance.mysql_standalone.password
}

# instance 
resource "aws_instance" "app_server" {
  ami                         = data.aws_ami.app.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_subnet-1a.id
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.app.name

  vpc_security_group_ids = [
    aws_security_group.app-sg.id,
    aws_security_group.opmng-sg.id,
  ]
  key_name = aws_key_pair.keypair.key_name

  tags = {
    Name    = "${var.project}-${var.environment}-keypair"
    project = var.project
    Env     = var.environment
    Type    = "app"
  }
}
