
resource "random_id" "server" {
  byte_length = 4
}
resource "aws_lb" "consul" {
  name               = "consul-lb-tf${random_id.server.hex}"
  internal           = false
  load_balancer_type = "network"

  subnet_mapping {
    subnet_id     = var.aws_subnet
  }

  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "consul" {
  load_balancer_arn = aws_lb.consul.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.consul.arn
  }
}

resource "aws_lb_target_group" "consul" {
  name     = "consul${random_id.server.hex}"
  port     = 8500
  protocol = "TCP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group_attachment" "consul" {
  target_group_arn = aws_lb_target_group.consul.arn
  target_id        = aws_instance.aws-consul.id
  port             = 8500
}

resource "aws_instance" "aws-consul" {
  ami                    = "ami-0a59f0e26c55590e9"
  instance_type          = "t2.medium"
  subnet_id              = var.aws_subnet
  vpc_security_group_ids = [aws_security_group.awsconsulserver.id]
  user_data              = base64encode(templatefile("${path.module}/scripts/awsconsul.sh", { 
    advertise_addr_wan = azurerm_public_ip.consul.ip_address,
    CONSUL_URL="https://releases.hashicorp.com/consul-terraform-sync",
    CTS_CONSUL_VERSION = "0.7.0",
    CONSUL_VERSION = "1.12.2",
    HOSTNAME = "${var.owner}-aws-consul-server${random_id.server.hex}"
  }))

  key_name               = aws_key_pair.demo.key_name
  associate_public_ip_address = true
  tags = {
    Name = "${var.owner}-aws-consul-server${random_id.server.hex}"
  }
}

resource "tls_private_key" "demo" {
  algorithm = "RSA"
}

resource "aws_key_pair" "demo" {
  public_key = tls_private_key.demo.public_key_openssh
  key_name                = "consulaws"
}

resource "null_resource" "key" {
  provisioner "local-exec" {
    command = "echo \"${tls_private_key.demo.private_key_pem}\" > ${aws_key_pair.demo.key_name}.pem"
  }

  provisioner "local-exec" {
    command = "chmod 600 *.pem"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rm -f *.pem"
  }


}



resource "aws_security_group" "awsconsulserver" {
  name   = "awsconsulserver"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8500
    to_port     = 8500
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8501
    to_port     = 8501
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3001
    to_port     = 3001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8301
    to_port     = 8301
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8302
    to_port     = 8302
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8302
    to_port     = 8302
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8303
    to_port     = 8303
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8300
    to_port     = 8300
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 9094
    to_port     = 9094
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
    from_port   = 8558
    to_port     = 8558
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}