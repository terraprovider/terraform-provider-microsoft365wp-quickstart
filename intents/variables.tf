variable "enable_workplace" {
  type    = bool
  default = true
}

variable "displayname_suffix" {
  type    = string
  default = " - TF"
}

variable "displayname_prefix" {
  type    = string
  default = ""
}

# Example of a complex object variable to configure a feature with multiple settings
variable "macos_firewall" {
  type = object({
    block_all_incoming = optional(bool, false)
    enable_stealth     = optional(bool, true)
  })
  default = {}
}

variable "policy_customization" {
  type = object({
    policies_disabled           = optional(list(string), [])
    policies_optional_enabled   = optional(list(string), [])
    policies_custom_definitions = optional(map(any), {})
  })
  default = {}
}

# Use this variable to acccess groups from the "groups" module
variable "groups_map" {
  type = any
}
