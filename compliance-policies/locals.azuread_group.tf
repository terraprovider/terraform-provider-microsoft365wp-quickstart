locals {
  base_all_azuread_groups = {
    for key, value in local.all_azuread_groups : key => {
      display_name            = value.display_name
      dynamic_membership      = try(value.dynamic_membership, false)
      dynamic_membership_rule = try(value.dynamic_membership_rule, "")
    }
  }
}
