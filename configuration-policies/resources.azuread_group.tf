# ------------------------------------------------------------------------------
# EntraID Groups
# ------------------------------------------------------------------------------

resource "azuread_group" "all" {
  for_each = local.base_azuread_group_resources_map

  display_name     = each.value.display_name
  description      = each.value.description
  mail_enabled     = false
  security_enabled = true

  types = each.value.dynamic_membership ? [
    "DynamicMembership"
  ] : []

  dynamic "dynamic_membership" {
    for_each = each.value.dynamic_membership ? [1] : []

    content {
      enabled = true
      rule    = each.value.dynamic_membership_rule
    }
  }

  prevent_duplicate_names = true
}
