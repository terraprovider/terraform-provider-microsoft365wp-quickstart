# ------------------------------------------------------------------------------
# EntraID Groups - resource
# ------------------------------------------------------------------------------

resource "azuread_group" "all" {
  for_each = local.base_azuread_groups_map

  display_name       = format("%s%s%s", each.value.naming.prefix, each.value.naming.name, each.value.naming.suffix)
  description        = each.value.description
  mail_enabled       = try(each.value.mail_enabled, false)
  security_enabled   = try(each.value.security_enabled, true)
  assignable_to_role = try(each.value.assignable_to_role, false)
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
}
