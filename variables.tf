## Global Settings

# Should this template create a breakglass account? If not, please create it ahead of time and specify it in "Settings" below.
variable "manage_breakglass_account" {
  description = "Should this template create a breakglass account? Not recommended in most cases."
  type        = bool
  default     = false
}

# Should this template create common groups like "all autopilot devices" etc.
# These are required - if you do not use the templates, please create them manually.
variable "manage_generic_groups" {
  description = "Should this template create common groups like 'all autopilot devices' etc. These are required - if you do not use the templates, please create them manually."
  type        = bool
  default     = true
}

# Create Filters. These are required - if you do not use the templates, please create them manually.
variable "manage_filters" {
  description = "Should this template create filters? Recommended for most scenarios."
  type        = bool
  default     = true
}

# Should this template create compliance policies?
variable "manage_compliance_policies" {
  description = "Should this template create compliance policies? Recommended for most scenarios."
  type        = bool
  default     = true
}

# Create Configuration Policies (= Settings Catalog Policies)
variable "manage_configuration_policies" {
  description = "Should this template create configuration policies ( = Settings Catalog policies)? Recommended for most scenarios."
  type        = bool
  default     = true
}

# Manage Device Management Intents (e.g. FileVault, BitLocker, Defender, etc.)
variable "manage_intents" {
  description = "Should this template create device management intents (e.g. FileVault, BitLocker, Defender, etc.)? Recommended for most scenarios."
  type        = bool
  default     = true
}

# Manage Autopilot Profiles
variable "manage_autopilot_profiles" {
  description = "Should this template create Autopilot profiles?"
  type        = bool
  default     = true
}

# Manage Device Enrollment Configurations ("Enrollment Status Page")
variable "manage_device_enrollment_configurations" {
  description = "Should this template create device enrollment configurations (ESP Page configuration)?"
  type        = bool
  default     = true
}

# Should this template create Windows policies regarding configuration and compliance? (configures multiple modules)
variable "enable_workplace_windows_macos" {
  description = "Should this template create Windows and MacOS policies regarding configuration and compliance? (configures multiple modules)"
  type        = bool
  default     = true
}

## Should Conditional Access be managed?
variable "manage_conditional_access" {
  description = "Should this template create conditional access policies?"
  type        = bool
  default     = false
}

# Create Device Configuration Policies (e.g. OMA Policies)
variable "manage_device_configuration" {
  description = "Should this template create device configuration policies (e.g. OMA Policies)?"
  type        = bool
  default     = true
}

# Create Windows Feature Update Profiles
variable "manage_windows_feature_update_profiles" {
  description = "Should this template create Windows Feature Update Profiles?"
  type        = bool
  default     = true
}

## Settings/Variables

# Names of the break glass accounts. The domain is automatically inferred.
# Set "manage_breakglass_account" to false if you want to create the account yourself. (recommended)
variable "breakglass_usernames" {
  description = "Names of the break glass accounts. The domain is automatically inferred. Set 'manage_breakglass_account' to 'false' if you want to create the account yourself."
  type        = set(string)
  default = [
    "cloudadmin"
  ]
}

# Rule for creating a dynamic group containing all administrative accounts
# if left empty the group is created as a non-dynamic group
variable "ca_all_admins_dynamic_group_rule" {
  description = "Rule for creating a dynamic group containing all administrative accounts. If left empty the group is created as a non-dynamic group."
  type        = string
  default     = "(user.userPrincipalName -startsWith \"adm.\")"
}

variable "all_autopilot_device_group_name" {
  description = "Name of the group containing all Autopilot devices"
  type        = string
  default     = "CFG - Devices - All Autopilot Devices - dyn"
}

variable "homepage" {
  description = "Homepage URL for browsers"
  type        = string
  default     = "https://office.com"
}

variable "client_prefix" {
  description = "Autopilot naming prefix for clients. The result will be `[yourVariable-]%SERIAL%`. Use empty string, `\"\"`, to disable any prefix."
  type        = string
  default     = "FWP-"
}

# Add this prefix to the display name of managed objects
variable "displayname_prefix" {
  description = "Prefix to add to the display name of managed objects"
  type        = string
  default     = ""
}

# Add this suffix to the display name of managed objects
variable "displayname_suffix" {
  description = "Suffix to add to the display name of managed objects"
  type        = string
  default     = ""
}

## Enable/Disable Features inside the modules

# Create iOS/Android Policies regarding configuration and compliance? (configures multiple modules)
variable "enable_mobile" {
  description = "Should this template create iOS/Android policies regarding configuration and compliance? (configures multiple modules)"
  type        = bool
  default     = true
}

## Settings

variable "compliance_ios_ipad_16_os_min_os_version" {
  description = "Minimum OS version for iOS/iPadOS 16 compliance"
  type        = string
  default     = "16.7.5"
}

variable "windows_11_feature_update_os_version" {
  description = "Windows 11 Feature Update desired OS Version"
  type        = string
  default     = "Windows 11, version 22H2"
}

variable "compliance_policy_customization" {
  description = <<EOT
  Which compliance policies should be enabled or disabled?

  Give the terraform object name of the desired policy, e.g. "win_default_device_health_bitlocker"

  - policies_disabled: Mandatory compliance policies that should be disabled. (not recommended)
  - policies_optional_enabled: Overwrite the default list of enabled optional compliance policies.
  EOT
  type = object({
    policies_disabled         = optional(list(string), [])
    policies_optional_enabled = optional(list(string), [])
  })
  default = {
  }
}

variable "groups_customization" {
  description = <<EOT
  Customize the groups that are created by the template.

  - groups_disabled: List of groups that should be disabled.
  - groups_custom_definitions: Map of custom group definitions.
  EOT
  type = object({
    groups_disabled           = optional(list(string), [])
    groups_custom_definitions = optional(map(any), {})
  })
  default = {
  }
}

variable "configuration_policy_customization" {
  description = <<EOT
  Which configuration policies should be enabled or disabled?

  Give the terraform object name of the desired policy, e.g. "macos_default_edge_home_and_start_page"

  - policies_disabled: Mandatory configuration policies that should be disabled. (not recommended)
  - policies_optional_enabled: Overwrite the default list of enabled optional configuration policies.
  EOT
  type = object({
    policies_disabled         = optional(list(string), [])
    policies_optional_enabled = optional(list(string), [])
  })
  default = {
  }
}

variable "device_configuration_customization" {
  description = <<EOT
  Which device configurations should be enabled or disabled?

  Give the terraform object name of the desired policy, e.g. "opt_win_default_cloud_trust"

  - policies_disabled: Mandatory configuration policies that should be disabled. (not recommended)
  - policies_optional_enabled: Overwrite the default list of enabled optional configuration policies.
  EOT
  type = object({
    policies_disabled         = optional(list(string), [])
    policies_optional_enabled = optional(list(string), [])
  })
  default = {
  }
}

variable "intents_policy_customization" {
  description = <<EOT
  Which macOS intent policies should be enabled or disabled?

  Give the terraform object name of the desired policy, e.g. "macos_default_filevault"

  - policies_disabled: Mandatory compliance policies that should be disabled. (not recommended)
  EOT
  type = object({
    policies_disabled = optional(list(string), [])
  })
  default = {
  }
}

variable "filters_customization" {
  description = <<EOT
  Which Intune filters should be created?

  - filters_disabled: List of filters that should be disabled.
  - filters_custom_definitions: Map of custom filter definitions.
  EOT
  type = object({
    filters_disabled           = optional(list(string), [])
    filters_custom_definitions = optional(map(any), {})
  })
  default = {
  }
}

variable "configuration_macos_firewall" {
  description = <<EOT
  macOS Firewall Configuration.

  Map of parameters:
  - block_all_incoming: (bool) Block all incoming connections
  - enable_stealth: (bool) Enable stealth mode
  EOT
  type = object({
    block_all_incoming = optional(bool, false)
    enable_stealth     = optional(bool, true)
  })
  default = {}
}

variable "device_enrollment_limit" {
  description = "The device enrollment limit for the ESP page. Must be between 1 and 15."
  type        = number
  default     = 15
  validation {
    condition     = var.device_enrollment_limit >= 1 && var.device_enrollment_limit <= 15
    error_message = "The device enrollment limit must be between 1 and 15."
  }
}
