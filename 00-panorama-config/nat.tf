
# outgoing nat rule
resource "panos_panorama_nat_rule_group" "egress-nat" {
  device_group = panos_device_group.devicegroup.name
  rulebase     = "pre-rulebase"
  rule {
    name          = "Allow outbound traffic"
    audit_comment = "Ticket 12345"
    original_packet {
      source_zones          = ["trust"]
      destination_zone      = "untrust"
      destination_interface = "ethernet1/1"
      source_addresses      = ["any"]
      destination_addresses = ["any"]
    }
    translated_packet {
      source {
        dynamic_ip_and_port {
          interface_address {
            interface = "ethernet1/1"
          }
        }
      }
      destination {}
    }
  }
}
