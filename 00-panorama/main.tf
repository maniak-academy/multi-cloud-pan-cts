
provider "panos" {
  hostname = "20.118.98.21"
  username = "panadmin"
  password = "2_tcmorvctzqxy1J"
}

resource "panos_panorama_template_stack" "stack" {
  count       = length(var.me)
  name        = "${var.me[count.index]}stack"
  templates = ["pantemplate"]
  description = "description here"
}


resource "panos_device_group_parent" "devicegroup" {
    count = length(var.me)
    device_group = "${var.me[count.index]}devicegroup"
    parent = "azure"
}

resource "panos_device_group" "devicegroup" {
  count = length(var.me)
  name  = "${var.me[count.index]}devicegroup"
}



variable "me" {
  type = list(string)
  default = [
    "seb",
    "paul",
    "frank",
  ]
}
