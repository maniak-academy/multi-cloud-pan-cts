

resource "panos_security_rule_group" "AccessRule" {
  position_keyword = "bottom"
  device_group     = panos_device_group.devicegroup.name
  rulebase         = "pre-rulebase"
  rule {
    name                  = "Allow Access to Logging Server"
    source_zones          = ["trust"]
    source_addresses      = ["cts-addr-grp-${var.owner}-app", "cts-addr-grp-${var.owner}-web"]
    source_users          = ["any"]
    destination_zones     = ["trust"]
    destination_addresses = ["cts-addr-grp-${var.owner}-logging"]
    applications          = ["any"]
    services              = ["any"]
    categories            = ["any"]
    action                = "allow"
  }
  rule {
    name                  = "Allow Access to App to Web"
    source_zones          = ["trust"]
    source_addresses      = ["cts-addr-grp-${var.owner}-app"]
    source_users          = ["any"]
    destination_zones     = ["trust"]
    destination_addresses = ["cts-addr-grp-${var.owner}-web"]
    applications          = ["any"]
    services              = ["any"]
    categories            = ["any"]
    action                = "allow"
  }
  rule {
    name                  = "Allow Access API to APPs"
    source_zones          = ["trust"]
    source_addresses      = ["cts-addr-grp-${var.owner}-api"]
    source_users          = ["any"]
    destination_zones     = ["trust"]
    destination_addresses = ["cts-addr-grp-${var.owner}-app"]
    applications          = ["any"]
    services              = ["any"]
    categories            = ["any"]
    action                = "allow"
  }
}


resource "panos_security_rule_group" "AllowAccessOutbound" {
  position_keyword = "top"
  device_group     = panos_device_group.devicegroup.name
  rulebase         = "pre-rulebase"
  rule {
    name                  = "Allow Access Outbound"
    source_zones          = ["trust"]
    source_addresses      = ["any"]
    source_users          = ["any"]
    destination_zones     = ["any"]
    destination_addresses = ["any"]
    applications          = ["any"]
    services              = ["any"]
    categories            = ["any"]
    action                = "allow"
  }
}