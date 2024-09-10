variable "client_prefix" {
  type    = string
  default = "FWP-"
}

# Use this to access groups created in the "groups" module
variable "groups_map" {
  type = any
}

locals {
  all_autopilot_devices_target = { group = { group_id = var.groups_map.all_autopilot_device.id } }
}
