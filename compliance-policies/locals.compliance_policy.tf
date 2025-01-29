locals {
  # Shorter notation
  policies_optional_enabled = var.policy_customization.policies_optional_enabled

  all_microsoft365wp_policies = merge(
    # Madatory Policies
    local.all_compliance_policies_workplace,
    # Optional Policies
    { for k, v in local.all_compliance_policies_workplace_optional : k => v if contains(local.policies_optional_enabled, k) }
  )

  all_mobile_policies = merge(
    # Mandatory Policies
    local.all_compliance_policies_mobile,
    # Optional Policies
    { for k, v in local.all_compliance_policies_mobile_optional : k => v if contains(local.policies_optional_enabled, k) }
  )

  all_compliance_policies_merged = merge(
    { for k, v in local.all_microsoft365wp_policies : k => v if var.include_workplace },
    { for k, v in local.all_mobile_policies : k => v if var.include_mobile },
    # Include custom policies
    var.policy_customization.policies_custom_definitions,
    # Include exported policies
    local.all_compliance_policies_exported
  )

  # Locals map for all compliance policies
  # Computed values to enable output/debugging
  base_all_compliance_policies = { for key, value in local.all_compliance_policies_merged : key => {
    display_name = format("%s%s%s", var.displayname_prefix, value.display_name, var.displayname_suffix)
    assignments = try(value.assignments, concat(
      # If there is a target group, add it to the assignments
      (try(value.target_group, "") != "" && try(value.target_group, "") != "all_users") ? [
        {
          target = merge(
            {
              group = {
                group_id = value.target_group
              }
            },
            # If filter is set, add it to the assignments
            try(value.filter_id, "") != "" ? {
              filter_id = value.filter_id
              # If filter_type is not set, default to exclude
              filter_type = try(value.filter_type, "exclude")
            } : {}
          )
        }
      ] : [],
      # If the target group is all_users, add it to the assignments
      try(value.target_group, "") == "all_users" ? [
        {
          target = merge(
            { all_licensed_users = {} },
            try(value.filter_id, "") != "" ? {
              filter_id = value.filter_id
              # If filter_type is not set, default to exclude
              filter_type = try(value.filter_type, "exclude")
            } : {}
          )
        }
      ] : [],
      # If there is no target group, use all devices (default)
      try(value.target_group, "") == "" ? [
        {
          target = merge(
            { all_devices = {} },
            try(value.filter_id, "") != "" ? {
              filter_id = value.filter_id
              # If filter_type is not set, default to exclude
              filter_type = try(value.filter_type, "exclude")
            } : {}
          )
        }
      ] : [],
      # If there are exclusion groups, add them to the assignments
      [for object_id in try(value.exclusion_groups, []) : {
        target = {
          exclusion_group = {
            group_id = object_id
          }
        } }
      ]
      )
    )
    scheduled_actions_for_rule = try(value.scheduled_actions_for_rule, null)
    windows10                  = try(value.windows10, null)
    macos                      = try(value.macos, null)
    aosp_device_owner          = try(value.aosp_device_owner, null)
    android                    = try(value.android, null)
    android_device_owner       = try(value.android_device_owner, null)
    android_work_profile       = try(value.android_work_profile, null)
    ios                        = try(value.ios, null)
  } }

  # Then concat it. See "locals.preset.tf" for presets/defaults. Include policies that are manually disabled.
  all_disabled_policies = distinct(concat(
    local.base_disabled_policies,
    var.policy_customization.policies_disabled
  ))

  # Filter out by keys that are not in the disabled_policies list
  all_compliance_policies_enabled = { for k, v in local.base_all_compliance_policies : k => v
    if !contains(local.all_disabled_policies, k)
  }
}
