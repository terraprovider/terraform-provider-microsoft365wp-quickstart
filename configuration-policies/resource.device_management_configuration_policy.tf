# ------------------------------------------------------------------------------
# Device Management Configuration Policy
# ------------------------------------------------------------------------------


resource "microsoft365wp_device_management_configuration_policy" "all" {
  for_each = local.base_device_configuration_policies_map

  name               = each.value.name
  description        = each.value.description
  assignments        = each.value.assignments
  settings           = each.value.settings
  platforms          = each.value.platforms
  technologies       = each.value.technologies
  template_reference = each.value.template_reference

  lifecycle {
    precondition {
      # Custom error message if the `instance` is not set correctly for each `settings` in the configuration policy
      condition     = length({ for key, value in each.value.settings : key => value if try(value.instance, null) != null }) == length({ for key, value in each.value.settings : key => value })
      error_message = format("The instance setting is not set correctly for configuration policy '%s' (key: '%s').", each.value.name, each.key)
    }

    precondition {
      // "Only one of arguments 'settings' or 'settings_json' can be set."
      condition     = each.value.settings == null || each.value.settings_json == null
      error_message = "Only one of arguments 'settings' or 'settings_json' can be set."
    }
  }
}


