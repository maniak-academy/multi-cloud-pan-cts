variable "aws_subnet" {
    type = string
}

variable "consul_server_ip" {}
variable "vpc_id" {}
variable "owner" {

}
variable "region" {
    default = "us-east-2"
}
variable "vault_addr" {
    type = string
}
variable "panos_mgmt_addr" {
    type = string
}