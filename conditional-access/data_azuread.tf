# Get the initial domain name
data "azuread_domains" "aad" {
  only_initial = true
}

# Get the break glass accounts
data "azuread_user" "breakglass" {
  for_each            = var.breakglass_usernames
  user_principal_name = "${each.value}@${data.azuread_domains.aad.domains[0].domain_name}"
}
