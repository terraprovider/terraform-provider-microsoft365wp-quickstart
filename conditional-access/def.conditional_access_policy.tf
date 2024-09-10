locals {
  all_conditional_access_policies = {
    admin_1_require_fido_or_tap = {
      display_name = "Admin 1 - Require FIDO"
      conditions = {
        applications = {
          include_applications = [
            "All"
          ]
        }
        client_app_types = [
          "browser",
          "mobileAppsAndDesktopClients"
        ]
        users = {
          exclude_users = setunion(
            local.breakglass_accounts_object_ids,
          )
          exclude_groups = [azuread_group.all["admin_1_exclusion_group"].id]
          include_groups = [azuread_group.all["ca_all_admins"].id]
        }
      }
      grant_controls = {
        authentication_strength = {
          id = microsoft365wp_authentication_strength_policy.all["fido"].id
        }
        operator = "OR"
      }
      session_controls = {
        sign_in_frequency = {
          value               = 10
          type                = "hours"
          authentication_type = "primaryAndSecondaryAuthentication"
          frequency_interval  = "timeBased"
          is_enabled          = true
        }
        persistent_browser = {
          is_enabled = true
          mode       = "never"
        }
        disable_resilience_defaults = false
      }
      # Change this after testing
      state = "disabled"
    }
    workplace_1_require_mfa = {
      display_name = "Workplace 1 - Require MFA for all Users"
      conditions = {
        applications = {
          include_applications = [
            "All"
          ]
        }
        client_app_types = [
          "browser",
          "mobileAppsAndDesktopClients"
        ]
        platforms = {
          include_platforms = [
            "all",
          ]
        }
        users = {
          exclude_groups = [
            azuread_group.all["ca_all_admins"].id,
            azuread_group.all["workplace_1_exclusion_group"].id
          ]
          include_users = ["All"]
          exclude_users = local.breakglass_accounts_object_ids
          exclude_guests_or_external_users = {
            external_tenants = {
              membership_kind = "all",
              all             = {}
            }
            guest_or_external_user_types = "internalGuest,b2bCollaborationGuest,b2bCollaborationMember,b2bDirectConnectUser,otherExternalUser,serviceProvider"
          }
        }
      }
      grant_controls = {
        authentication_strength = {
          # static id
          id = "00000000-0000-0000-0000-000000000002"
        }
        operator = "OR"
      }
      # Change this after testing
      state = "disabled"
    }
  }
}
