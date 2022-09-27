
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "3.14.4"

  name = "consul-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
  public_subnets  = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]

  enable_ipv6 = true

  enable_nat_gateway = false
  single_nat_gateway = true

  tags = {
    Owner       = var.owner
  }
}


