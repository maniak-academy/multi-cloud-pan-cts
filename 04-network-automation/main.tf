
data "terraform_remote_state" "environment" {
  backend = "local"

  config = {
    path = "../01-infra-cloud/terraform.tfstate"
  }
}

module "cts-aws" {
  source = "./cts-aws"
  aws_subnet     = data.terraform_remote_state.environment.outputs.aws-public-subnet
  owner = data.terraform_remote_state.environment.outputs.owner
  consul_server_ip       = data.terraform_remote_state.environment.outputs.aws_consul_private_ip
  vpc_id = data.terraform_remote_state.environment.outputs.vpc_id
  vault_addr = data.terraform_remote_state.environment.outputs.vaultlb2
  panos_mgmt_addr = var.aws_panos_mgmt_addr
}
