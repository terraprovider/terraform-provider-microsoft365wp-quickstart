variable "policy_customization" {
  type = object({
    policies_disabled           = optional(list(string), [])
    policies_optional_enabled   = optional(list(string), [])
    policies_custom_definitions = optional(map(any), {})
  })
  default = {}
}

variable "displayname_suffix" {
  type    = string
  default = " - TF"
}

variable "displayname_prefix" {
  type    = string
  default = ""
}

# Use this to access filters from the "filters" module
variable "filters_map" {
  type = any
}

# Use this to access groups from the "groups" module
variable "groups_map" {
  type = any
}

variable "enable_mobile" {
  type    = bool
  default = true
}

variable "enable_workplace" {
  type    = bool
  default = true
}

