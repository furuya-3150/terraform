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

resource "aws_instance" "app_server" {
  ami                         = data.aws_ami.app.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_subnet-1a.id
  associate_public_ip_address = true
  vpc_security_group_ids = [
    aws_security_group.app-sg.id,
    aws_security_group.opmng-sg.id,
  ]

  tags = {
    Name    = "${var.project}-${var.environment}-keypair"
    project = var.project
    Env     = var.environment
    Type    = "app"
  }
}
