variable "include_mobile" {
  type    = bool
  default = true
}

variable "include_workplace" {
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

variable "compliance_ios_ipad_16_os_min_os_version" {
  type    = string
  default = "16.7.5"
}

# Enable, Disable, or Customize Compliance Policies
variable "policy_customization" {
  type = object({
    policies_disabled           = optional(list(string), [])
    policies_optional_enabled   = optional(list(string), [])
    policies_custom_definitions = optional(map(any), {})
  })
  default = {}
}

# Use this to access filters created in the "filters" module
variable "filters_map" {
  type = any
}

# Use this to access groups created in the "groups" module
variable "groups_map" {
  type = any
}
