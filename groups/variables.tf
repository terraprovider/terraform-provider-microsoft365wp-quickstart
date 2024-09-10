variable "all_autopilot_device_group_name" {
  type    = string
  default = "CFG - Devices - All Autopilot Devices - dyn"
}

variable "displayname_suffix" {
  type    = string
  default = " - TF"
}

variable "displayname_prefix" {
  type    = string
  default = ""
}

variable "groups_customization" {
  type = object({
    groups_disabled           = optional(list(string), [])
    groups_custom_definitions = optional(map(any), {})
  })
  default = {}
}
