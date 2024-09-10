resource "microsoft365wp_conditional_access_policy" "all" {
  for_each = local.all_conditional_access_policies

  display_name     = format("%s%s%s", var.displayname_prefix, each.value.display_name, var.displayname_suffix)
  state            = try(each.value.state, "enabled")
  conditions       = try(each.value.conditions, null)
  grant_controls   = try(each.value.grant_controls, null)
  session_controls = try(each.value.session_controls, null)
}
