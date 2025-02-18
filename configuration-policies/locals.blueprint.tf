locals {

  # Targeting configuration
  ref_all_users_target   = { all_licensed_users = {} }
  ref_all_devices_target = { all_devices = {} }

  # Intent assignments targets based on the configuration
  base_target_all_users   = local.ref_all_users_target
  base_target_all_devices = local.ref_all_devices_target
}

locals {

  # Configuration policies map - Workplace
  device_configuration_policies_workplace_map = merge(
    # Madatory Policies
    local.configuration_policy_workplace_win_map,
    local.configuration_policy_workplace_macos_map,
    # Optional Policies
    { for k, v in local.configuration_policy_workplace_optional_map : k => v if contains(var.policy_customization.policies_optional_enabled, k) },
    { for k, v in local.configuration_policy_workplace_win_optional_map : k => v if contains(var.policy_customization.policies_optional_enabled, k) },
  )

  # Configuration policies map - Mobile
  device_configuration_policies_mobile_map = merge(
    # Mandatory Policies
    local.configuration_policy_mobile_ios_ipad_map,
    # Optional Policies
    { for k, v in local.configuration_policy_mobile_ios_ipad_optional_map : k => v if contains(var.policy_customization.policies_optional_enabled, k) }
  )

  # Merge all the policies
  device_configuration_policies_merged = merge(
    { for k, v in local.device_configuration_policies_workplace_map : k => v if var.include_workplace },
    { for k, v in local.device_configuration_policies_mobile_map : k => v if var.include_mobile },
    local.all_configuration_policies_exported,
    # Include custom policies
    var.policy_customization.policies_custom_definitions
  )

  # Use presets to filter out policies
  device_configuration_policies_disabled_list = distinct(concat(
    # Disable base policies (emergency cases or testing)
    local.base_disabled_policies_list,
    # Disable custom policies
    var.policy_customization.policies_disabled
  ))

  # Filter out by keys that are not in the disabled_policies list
  device_configuration_policies_filtered_map = { for k, v in local.device_configuration_policies_merged : k => v
    if !contains(local.device_configuration_policies_disabled_list, k)
  }

  # Map the policies to the format required by the API (Note this is not a base map)

  device_configuration_policies_map = { for key, value in local.device_configuration_policies_filtered_map : key =>
    {
      name        = format("%s%s%s", var.displayname_prefix, value.name, var.displayname_suffix)
      description = try(value.description, null)

      assignments = concat(
        [for a in try(value.assignments, []) : {
          target = {
            all_devices        = try(a.target.all_devices, null) != null ? a.target.all_devices : null,
            all_licensed_users = try(a.target.all_licensed_users, null) != null ? a.target.all_licensed_users : null,
            exclusion_group = try(a.target.exclusion_group, null) != null ? {
              group_id = a.target.exclusion_group.group_id
            } : null,
            filter_id   = try(a.target.filter_id, null)
            filter_type = try(a.target.filter_type, null)
            group = try(a.target.group, null) != null ? {
              group_id = a.target.group.group_id
            } : null
          }
        }],
      )

      settings           = try(value.settings, null)
      settings_json      = try(value.settings_json, null)
      platforms          = try(value.platforms, null)
      role_scope_tag_ids = try(value.role_scope_tag_ids, null)
      technologies       = try(value.technologies, null)
      template_reference = try(value.template_reference, null) != null ? {
        # `workplace_device_management_configuration_policy require` id
        # `workplace_device_management_configuration_policy_json` require `template_id`
        id          = try(value.template_reference.id, null)
        template_id = try(value.template_reference.template_id, null)
      } : null
    }
  }

  # Base maps for the device configuration policies
  # Due to the limitation of resource, we need to split the map based on ignore settings in the lifecycle block for specific policies

  base_device_configuration_policies_map = { for key, value in local.device_configuration_policies_map : key => value if try(value.settings, null) != null }
}
