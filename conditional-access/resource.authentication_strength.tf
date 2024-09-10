resource "microsoft365wp_authentication_strength_policy" "all" {
  for_each = local.all_authentications_strength_policies

  display_name         = format("%s%s%s", var.displayname_prefix, each.value.display_name, var.displayname_suffix)
  allowed_combinations = each.value.allowed_combinations
}
