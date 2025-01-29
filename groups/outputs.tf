# ------------------------------------------------------------------------------
# EntraID Groups - output resource references
# ------------------------------------------------------------------------------

locals {
  base_azuread_groups_resource_map = { for group_key, group in local.base_azuread_groups_map : group_key => {
    id           = try(azuread_group.all[group_key].id, null)
    display_name = try(azuread_group.all[group_key].display_name, null)
  } }
}

output "groups_map" {
  value = local.base_azuread_groups_resource_map
}
