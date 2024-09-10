# Template for all EntraID Groups
resource "azuread_group" "all" {
  for_each = local.base_all_azuread_groups

  display_name     = format("%s%s%s", var.displayname_prefix, each.value.display_name, var.displayname_suffix)
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
}
