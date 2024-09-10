variable "displayname_suffix" {
  type    = string
  default = " - TF"
}

variable "displayname_prefix" {
  type    = string
  default = ""
}

variable "device_enrollment_limit" {
  type    = number
  default = 15
}

# Use this to access filters from the "filters" module
variable "filters_map" {
  type = any
}

# Use this to access groups from the "groups" module
variable "groups_map" {
  type = any
}

locals {
  all_users_target   = { all_licensed_users = {} }
  all_devices_target = { all_devices = {} }
}
