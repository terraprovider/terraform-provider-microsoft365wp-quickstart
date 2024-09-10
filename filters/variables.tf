variable "displayname_suffix" {
  type    = string
  default = " - TF"
}

variable "displayname_prefix" {
  type    = string
  default = ""
}

variable "include_mobile" {
  type    = bool
  default = true
}

variable "include_workplace" {
  type    = bool
  default = true
}

# Use this to disable filters or add custom filters
variable "filters_customization" {
  type = object({
    filters_disabled           = optional(list(string), [])
    filters_custom_definitions = optional(map(any), {})
  })
  default = {}
}
