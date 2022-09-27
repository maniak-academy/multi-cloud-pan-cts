
resource "panos_panorama_address_group" "cts-addr-grp-app" {
  name          = "cts-addr-grp-${var.owner}-app"
  description   = "My internal APP servers"
  dynamic_match = "${var.owner}-app"
  device_group  = panos_device_group.devicegroup.name
}

resource "panos_panorama_address_group" "cts-addr-grp-logging" {
  name          = "cts-addr-grp-${var.owner}-logging"
  description   = "My internal logging servers"
  dynamic_match = "${var.owner}-logging"
  device_group  = panos_device_group.devicegroup.name
}

resource "panos_panorama_address_group" "cts-addr-grp-web" {
  name          = "cts-addr-grp-${var.owner}-web"
  description   = "My internal web servers"
  dynamic_match = "${var.owner}-web"
  device_group  = panos_device_group.devicegroup.name
}

resource "panos_panorama_address_group" "cts-addr-grp-api" {
  name          = "cts-addr-grp-${var.owner}-api"
  description   = "My internal web servers"
  dynamic_match = "${var.owner}-api"
  device_group  = panos_device_group.devicegroup.name
}
