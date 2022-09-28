
provider "panos" {
  hostname = ""
  username = "panadmin"
  password = ""
}

resource "panos_panorama_template_stack" "stack" {
  count       = length(var.me)
  name        = "${var.me[count.index]}stack"
  templates   = ["pantemplate"]
  description = "description here"
}


resource "panos_device_group_parent" "devicegroup" {
  count        = length(var.me)
  device_group = "${var.me[count.index]}devicegroup"
  depends_on = [
    panos_device_group.devicegroup
  ]
}

resource "panos_device_group" "devicegroup" {
  count = length(var.me)
  name  = "${var.me[count.index]}devicegroup"
}


# resource "panos_device_group_parent" "awsdevicegroup" {
#     count = length(var.me)
#     device_group = "${var.me[count.index]}awsdevicegroup"
#     parent = "aws"
#     depends_on = [
#       panos_device_group.awsdevicegroup
#     ]
# }

# resource "panos_device_group" "awsdevicegroup" {
#   count = length(var.me)
#   name  = "${var.me[count.index]}awsdevicegroup"
# }


# resource "panos_device_group_parent" "gcpdevicegroup" {
#     count = length(var.me)
#     device_group = "${var.me[count.index]}gcpdevicegroup"
#     parent = "gcp"
#     depends_on = [
#       panos_device_group.gcpdevicegroup
#     ]
# }

# resource "panos_device_group" "gcpdevicegroup" {
#   count = length(var.me)
#   name  = "${var.me[count.index]}gcpdevicegroup"
# }



variable "me" {
  type = list(string)
  default = [
    "seb",
    "paul",
    "mike",
    "migara",
    "jason",
    "group1",
    "group2",
    "group3",
    "group4",
    "group5",
    "group6",
    "group7",
    "group8",
    "group9",
    "group10",
  ]
}
