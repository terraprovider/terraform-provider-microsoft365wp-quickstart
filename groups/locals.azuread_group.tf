# ------------------------------------------------------------------------------
# EntraID Groups - locals
# ------------------------------------------------------------------------------

locals {

  base_azuread_groups_map = { for k, v in merge(local.azuread_groups_definitions_map) : k => {
    naming = {
      prefix = var.displayname_prefix
      name   = v.display_name
      suffix = var.displayname_suffix
    }
    description             = try(v.description, "")
    dynamic_membership      = try(v.dynamic_membership, false)
    dynamic_membership_rule = try(v.dynamic_membership_rule, "")
  } }
}

output "debug_groups" {
  value = local.base_azuread_groups_map
}
