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

variable "windows_11_feature_update_os_version" {
  type    = string
  default = "Windows 11, version 22H2"
}
