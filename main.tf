## Data sources
data "azuread_client_config" "current" {}

## Modules

# Just a demonstration. Managing users via terraform is not recommended as credentials could be exposed in the state file.
module "users" {
  count                = var.manage_breakglass_account ? 1 : 0
  source               = "./users"
  breakglass_usernames = var.breakglass_usernames
}

# "Groups" that are used accross multiple modules
module "groups" {
  count                           = var.manage_generic_groups ? 1 : 0
  source                          = "./groups"
  all_autopilot_device_group_name = var.all_autopilot_device_group_name
  displayname_suffix              = var.displayname_suffix
  displayname_prefix              = var.displayname_prefix
  groups_customization            = var.groups_customization
}

# Intune filters are used to target policies to specific devices
module "filters" {
  count                 = var.manage_filters ? 1 : 0
  source                = "./filters"
  displayname_suffix    = var.displayname_suffix
  displayname_prefix    = var.displayname_prefix
  filters_customization = var.filters_customization
}

module "conditional_access" {
  count                            = var.manage_conditional_access ? 1 : 0
  source                           = "./conditional-access"
  breakglass_usernames             = var.breakglass_usernames
  ca_all_admins_dynamic_group_rule = var.ca_all_admins_dynamic_group_rule
  depends_on = [
    module.users
  ]
  displayname_prefix = var.displayname_prefix
  displayname_suffix = var.displayname_suffix
}

module "autopilot_profiles" {
  count  = var.manage_autopilot_profiles ? 1 : 0
  source = "./autopilot-profiles"
  depends_on = [
    module.groups
  ]
  client_prefix = var.client_prefix
  groups_map    = module.groups[0].groups_map
}

module "compliance_policies" {
  count              = var.manage_compliance_policies ? 1 : 0
  source             = "./compliance-policies"
  include_mobile     = var.enable_mobile
  include_workplace  = var.enable_workplace_windows_macos
  displayname_suffix = var.displayname_suffix
  displayname_prefix = var.displayname_prefix
  depends_on = [
    module.groups,
    module.filters
  ]
  compliance_ios_ipad_16_os_min_os_version = var.compliance_ios_ipad_16_os_min_os_version
  policy_customization                     = var.compliance_policy_customization
  groups_map                               = module.groups[0].groups_map
  filters_map                              = module.filters[0].filters_map
}

# "Configuration Policies" are the new way to configure settings in Intune (i.e. "Settings Catalog")
# Some policies also configure Endpoint Security settings
module "configuration_policies" {
  count              = var.manage_configuration_policies ? 1 : 0
  source             = "./configuration-policies"
  include_mobile     = var.enable_mobile
  include_workplace  = var.enable_workplace_windows_macos
  displayname_suffix = var.displayname_suffix
  displayname_prefix = var.displayname_prefix
  depends_on = [
    module.groups,
    module.filters
  ]
  policy_customization = var.configuration_policy_customization
  groups_map           = module.groups[0].groups_map
  filters_map          = module.filters[0].filters_map
}

# "Device Configuration" id one of the classic policy types in Intune
module "device_configuration" {
  count              = var.manage_device_configuration ? 1 : 0
  source             = "./device-configuration"
  enable_mobile      = var.enable_mobile
  enable_workplace   = var.enable_workplace_windows_macos
  displayname_suffix = var.displayname_suffix
  displayname_prefix = var.displayname_prefix
  depends_on = [
    module.groups,
    module.filters
  ]
  policy_customization = var.device_configuration_customization
  groups_map           = module.groups[0].groups_map
  filters_map          = module.filters[0].filters_map
}

# "Device Enrollment Configurations" are used to configure the enrollment experience for devices
module "device_enrollment_configurations" {
  count              = var.manage_device_enrollment_configurations ? 1 : 0
  source             = "./device-enrollment-configurations"
  displayname_suffix = var.displayname_suffix
  displayname_prefix = var.displayname_prefix
  groups_map         = module.groups[0].groups_map
  filters_map        = module.filters[0].filters_map
  # Example: Transport simple values into a module
  device_enrollment_limit = var.device_enrollment_limit
}

# "Intents" are MacOS specific settings that can be configured via Intune
# Some policies also configure Endpoint Security settings
module "intents" {
  count  = var.manage_intents ? 1 : 0
  source = "./intents"
  depends_on = [
    module.groups
  ]
  groups_map         = module.groups[0].groups_map
  enable_workplace   = var.enable_workplace_windows_macos
  displayname_suffix = var.displayname_suffix
  displayname_prefix = var.displayname_prefix
  # Example: Transport complex objects into a module to configure a feature with multiple settings
  macos_firewall       = var.configuration_macos_firewall
  policy_customization = var.intents_policy_customization
}

# Enforce Windows Feature Update Deployment using Feature Update Profiles
module "windows_feature_update_profiles" {
  count              = var.manage_windows_feature_update_profiles ? 1 : 0
  source             = "./windows-feature-update"
  enable_workplace   = var.enable_workplace_windows_macos
  displayname_suffix = var.displayname_suffix
  displayname_prefix = var.displayname_prefix
  # Example: Transport simple values into a module
  windows_11_feature_update_os_version = var.windows_11_feature_update_os_version
}
