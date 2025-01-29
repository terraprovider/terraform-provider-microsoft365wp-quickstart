# ------------------------------------------------------------------------------
# EntraID Groups - locals
# ------------------------------------------------------------------------------

locals {

  merged_groups_map = merge(
    local.azuread_groups_definitions_map,
    local.azuread_groups_exported_map,
  )

  base_azuread_groups_map = { for k, v in merge(local.merged_groups_map) : k => {
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
