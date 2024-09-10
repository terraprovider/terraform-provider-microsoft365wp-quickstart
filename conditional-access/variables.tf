variable "breakglass_usernames" {
  type = set(string)
  default = [
    "cloudadmin"
  ]
}

variable "displayname_prefix" {
  type    = string
  default = ""
}

variable "displayname_suffix" {
  type    = string
  default = " - TF"
}

variable "ca_all_admins_dynamic_group_rule" {
  type    = string
  default = "(user.userPrincipalName -startsWith \"adm.\")"
}

locals {
  breakglass_accounts_object_ids = [
    for user in data.azuread_user.breakglass : user.id
  ]
}
