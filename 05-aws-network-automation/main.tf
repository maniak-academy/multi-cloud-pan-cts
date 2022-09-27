terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.32.0"
    }
  }
}

provider "aws" {
  region = var.region
}

data "terraform_remote_state" "environment" {
  backend = "local"

  config = {
    path = "../01-infra-cloud/terraform.tfstate"
  }
}


resource "random_id" "server" {
  byte_length = 4
}


resource "aws_network_interface" "foo" {
  subnet_id   = data.terraform_remote_state.environment.outputs.aws-public-subnet
  security_groups = [aws_security_group.awscts.id]

  tags = {
    Name = "primary_network_interface${random_id.server.hex}"
  }
}

resource "aws_instance" "cts-server" {
  ami                    = "ami-0a59f0e26c55590e9"
  instance_type          = "t2.medium"
  # subnet_id              = data.terraform_remote_state.environment.outputs.aws-public-subnet
  # vpc_security_group_ids = [aws_security_group.awscts.id]
  
  network_interface {
    network_interface_id = aws_network_interface.foo.id
    device_index         = 0
  }
  user_data              = base64encode(templatefile("${path.module}/scripts/consul-tf-sync.sh", { 
    consul_server_ip = data.terraform_remote_state.environment.outputs.aws_consul_private_ip,
    vault_token = "root", 
    vault_addr = data.terraform_remote_state.environment.outputs.vaultlb2, 
    CONSUL_VERSION = "1.12.2",
    CTS_CONSUL_VERSION = "0.7.0",
    CONSUL_URL = "https://releases.hashicorp.com/consul-terraform-sync",
    owner = data.terraform_remote_state.environment.outputs.owner,
    panos_mgmt_addr =  var.aws_panos_mgmt_addr,
    local_ipv4 = aws_network_interface.foo.private_ip,
    HOSTNAME = "${data.terraform_remote_state.environment.outputs.owner}-cts-vm${random_id.server.hex}"
  }))

  key_name               = aws_key_pair.demo.key_name
  # associate_public_ip_address = false
  tags = {
    Name = "${data.terraform_remote_state.environment.outputs.owner}-aws-cts-server${random_id.server.hex}"
  }
}

resource "tls_private_key" "demo" {
  algorithm = "RSA"
}

resource "aws_key_pair" "demo" {
  public_key = tls_private_key.demo.public_key_openssh

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


