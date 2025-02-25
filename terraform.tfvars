## Use this file to customize the behavior of your setup

## Global Settings (Modules)

# Should this template create common groups like "all autopilot devices" etc.
# These are required - if you do not use the templates, please create them manually.
manage_generic_groups = true

# Create Filters. These are required - if you do not use the templates, please create them manually.
manage_filters = true

# Should this template create compliance policies?
manage_compliance_policies = true

# Create Configuration Policies (= Settings Catalog Policies)
manage_configuration_policies = true

## Conditional Access is currently only implemented to a minimum degree to enforce MFA.
manage_conditional_access = true

# Create Device Configuration Policies (e.g. OMA Policies)
manage_device_configuration = true

# Mange Windows Device Enrollment Configurations ("Enrollment Status Page" and "Limits")
manage_device_enrollment_configurations = true

## Enable/Disable Features accross Modules

# Should this template create Windows and MacOS policies regarding configuration and compliance? (configures multiple modules)
enable_workplace_windows_macos = true

# Create iOS/Android Policies regarding configuration and compliance? (configures multiple modules)
enable_mobile = true

## Settings/Variables

# Names of the break glass accounts. The domain is automatically inferred.
# Set "manage_breakglass_account" to false if you want to create the account yourself.
# If you let terraform manage the break glass account you need to add it to this set.
breakglass_usernames = [
  "cloudadmin"
]

# Browser Settings
homepage = "https://office.com"

# Group names
all_autopilot_device_group_name = "CFG - Devices - All Autopilot Devices - dyn"

# MacOS Firewall Settings (Example for a complex setting)
configuration_macos_firewall = {
  block_all_incoming = false
  enable_stealth     = false
}

## See `variables.tf` for more settings
