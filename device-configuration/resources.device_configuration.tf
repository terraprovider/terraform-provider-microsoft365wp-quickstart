# ------------------------------------------------------------------------------
# Device Configuration Policies
# ------------------------------------------------------------------------------

resource "microsoft365wp_device_configuration" "all" {
  for_each = local.base_device_configuration_policies_map

  display_name = each.value.display_name
  description  = each.value.description

  assignments = each.value.assignments

  android_device_owner_general_device              = each.value.android_device_owner_general_device
  device_management_applicability_rule_device_mode = each.value.device_management_applicability_rule_device_mode
  device_management_applicability_rule_os_edition  = each.value.device_management_applicability_rule_os_edition
  device_management_applicability_rule_os_version  = each.value.device_management_applicability_rule_os_version
  ios_custom                                       = each.value.ios_custom
  ios_device_features                              = each.value.ios_device_features
  ios_eas_email_profile                            = each.value.ios_eas_email_profile
  ios_general_device                               = each.value.ios_general_device
  ios_update                                       = each.value.ios_update
  ios_vpn                                          = each.value.ios_vpn
  macos_custom                                     = each.value.macos_custom
  macos_custom_app                                 = each.value.macos_custom_app
  macos_device_features                            = each.value.macos_device_features
  macos_extensions                                 = each.value.macos_extensions
  macos_software_update                            = each.value.macos_software_update
  role_scope_tag_ids                               = each.value.role_scope_tag_ids
  windows_health_monitoring                        = each.value.windows_health_monitoring
  windows_update_for_business                      = each.value.windows_update_for_business
}

resource "microsoft365wp_device_configuration_custom" "all" {
  for_each = local.base_device_configuration_policies_custom_map

  display_name = each.value.display_name
  description  = each.value.description

  assignments = each.value.assignments

  device_management_applicability_rule_device_mode = each.value.device_management_applicability_rule_device_mode
  device_management_applicability_rule_os_edition  = each.value.device_management_applicability_rule_os_edition
  device_management_applicability_rule_os_version  = each.value.device_management_applicability_rule_os_version
  role_scope_tag_ids                               = each.value.role_scope_tag_ids
  windows10                                        = each.value.windows10
}
