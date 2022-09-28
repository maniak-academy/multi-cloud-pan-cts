
provider "panos" {
  hostname = var.panorama_ip
  username = var.panorama_username
  password = var.panorama_password
}

resource "panos_device_group" "devicegroup" {
  name = "${var.owner}devicegroup"
}

resource "panos_panorama_template_stack" "stack" {
  name        = "${var.owner}stack"
  templates   = ["pantemplate"]
  description = "description here"
}
