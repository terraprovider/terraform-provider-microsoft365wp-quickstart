# ------------------------------------------------------------------------------
# EntraID Groups
# ------------------------------------------------------------------------------

locals {
  # Base Groups map
  base_azuread_group_resources_map = {
    for key, value in local.azuread_group_resources_map : key => {
      display_name            = format("%s%s%s", var.displayname_prefix, value.display_name, var.displayname_suffix)
      description             = try(value.description, null)
      dynamic_membership      = try(value.dynamic_membership, false)
      dynamic_membership_rule = try(value.dynamic_membership_rule, null)
    }
  }
}
