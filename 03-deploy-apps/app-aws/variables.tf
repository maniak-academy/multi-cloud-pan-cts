variable "aws_subnet" {
    type = string
}

variable "aws_app_count" {
    type = string
}
variable "consul_server_ip" {}
variable "vpc_id" {}
variable "owner" {

}
variable "region" {
    default = "us-east-2"
}
