locals {
  # Define Groups to target assignments
  all_azuread_groups = {
    admin_1_exclusion_group = {
      display_name = "CFG - CA - Exclusion - Admin 1"
    }
    workplace_1_exclusion_group = {
      display_name = "CFG - CA - Exclusion - Workplace 1"
    }
    ca_all_admins = {
      display_name            = "CFG - CA - All Admins"
      description             = "All Admin accounts"
      dynamic_membership      = true
      dynamic_membership_rule = "(user.userPrincipalName -startsWith \"adm.\")"
    }
  }
}
