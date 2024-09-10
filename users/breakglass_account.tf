resource "azuread_user" "breakglass_account" {
  for_each            = var.breakglass_usernames
  user_principal_name = "${each.key}@${data.azuread_domains.aad.domains.0.domain_name}"
  display_name        = "ADM - Break Glass Account - ${each.key}"
}
