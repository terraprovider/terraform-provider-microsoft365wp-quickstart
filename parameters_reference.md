<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.7)

- <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) (2.47.0)

- <a name="requirement_microsoft365wp"></a> [microsoft365wp](#requirement\_microsoft365wp) (0.12.9)

## Required Inputs

No required inputs.

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_all_autopilot_device_group_name"></a> [all\_autopilot\_device\_group\_name](#input\_all\_autopilot\_device\_group\_name)

Description: Name of the group containing all Autopilot devices

Type: `string`

Default: `"CFG - Devices - All Autopilot Devices - dyn"`

### <a name="input_breakglass_usernames"></a> [breakglass\_usernames](#input\_breakglass\_usernames)

Description: Names of the break glass accounts. The domain is automatically inferred. Set 'manage\_breakglass\_account' to 'false' if you want to create the account yourself.

Type: `set(string)`

Default:

```json
[
  "cloudadmin"
]
```

### <a name="input_ca_all_admins_dynamic_group_rule"></a> [ca\_all\_admins\_dynamic\_group\_rule](#input\_ca\_all\_admins\_dynamic\_group\_rule)

Description: Rule for creating a dynamic group containing all administrative accounts. If left empty the group is created as a non-dynamic group.

Type: `string`

Default: `"(user.userPrincipalName -startsWith \"adm.\")"`

### <a name="input_client_prefix"></a> [client\_prefix](#input\_client\_prefix)

Description: Autopilot naming prefix for clients. The result will be `[yourVariable-]%SERIAL%`. Use empty string, `""`, to disable any prefix.

Type: `string`

Default: `"FWP-"`

### <a name="input_compliance_ios_ipad_16_os_min_os_version"></a> [compliance\_ios\_ipad\_16\_os\_min\_os\_version](#input\_compliance\_ios\_ipad\_16\_os\_min\_os\_version)

Description: Minimum OS version for iOS/iPadOS 16 compliance

Type: `string`

Default: `"16.7.5"`

### <a name="input_compliance_policy_customization"></a> [compliance\_policy\_customization](#input\_compliance\_policy\_customization)

Description:   Which compliance policies should be enabled or disabled?

  Give the terraform object name of the desired policy, e.g. "win\_default\_device\_health\_bitlocker"

  - policies\_disabled: Mandatory compliance policies that should be disabled. (not recommended)
  - policies\_optional\_enabled: Overwrite the default list of enabled optional compliance policies.

Type:

```hcl
object({
    policies_disabled         = optional(list(string), [])
    policies_optional_enabled = optional(list(string), [])
  })
```

Default: `{}`

### <a name="input_configuration_macos_firewall"></a> [configuration\_macos\_firewall](#input\_configuration\_macos\_firewall)

Description:   macOS Firewall Configuration.

  Map of parameters:
  - block\_all\_incoming: (bool) Block all incoming connections
  - enable\_stealth: (bool) Enable stealth mode

Type:

```hcl
object({
    block_all_incoming = optional(bool, false)
    enable_stealth     = optional(bool, true)
  })
```

Default: `{}`

### <a name="input_configuration_policy_customization"></a> [configuration\_policy\_customization](#input\_configuration\_policy\_customization)

Description:   Which configuration policies should be enabled or disabled?

  Give the terraform object name of the desired policy, e.g. "macos\_default\_edge\_home\_and\_start\_page"

  - policies\_disabled: Mandatory configuration policies that should be disabled. (not recommended)
  - policies\_optional\_enabled: Overwrite the default list of enabled optional configuration policies.

Type:

```hcl
object({
    policies_disabled         = optional(list(string), [])
    policies_optional_enabled = optional(list(string), [])
  })
```

Default: `{}`

### <a name="input_device_configuration_customization"></a> [device\_configuration\_customization](#input\_device\_configuration\_customization)

Description:   Which device configurations should be enabled or disabled?

  Give the terraform object name of the desired policy, e.g. "opt\_win\_default\_cloud\_trust"

  - policies\_disabled: Mandatory configuration policies that should be disabled. (not recommended)
  - policies\_optional\_enabled: Overwrite the default list of enabled optional configuration policies.

Type:

```hcl
object({
    policies_disabled         = optional(list(string), [])
    policies_optional_enabled = optional(list(string), [])
  })
```

Default: `{}`

### <a name="input_device_enrollment_limit"></a> [device\_enrollment\_limit](#input\_device\_enrollment\_limit)

Description: The device enrollment limit for the ESP page. Must be between 1 and 15.

Type: `number`

Default: `15`

### <a name="input_displayname_prefix"></a> [displayname\_prefix](#input\_displayname\_prefix)

Description: Prefix to add to the display name of managed objects

Type: `string`

Default: `""`

### <a name="input_displayname_suffix"></a> [displayname\_suffix](#input\_displayname\_suffix)

Description: Suffix to add to the display name of managed objects

Type: `string`

Default: `""`

### <a name="input_enable_mobile"></a> [enable\_mobile](#input\_enable\_mobile)

Description: Should this template create iOS/Android policies regarding configuration and compliance? (configures multiple modules)

Type: `bool`

Default: `true`

### <a name="input_enable_workplace_windows_macos"></a> [enable\_workplace\_windows\_macos](#input\_enable\_workplace\_windows\_macos)

Description: Should this template create Windows and MacOS policies regarding configuration and compliance? (configures multiple modules)

Type: `bool`

Default: `true`

### <a name="input_filters_customization"></a> [filters\_customization](#input\_filters\_customization)

Description:   Which Intune filters should be created?

  - filters\_disabled: List of filters that should be disabled.
  - filters\_custom\_definitions: Map of custom filter definitions.

Type:

```hcl
object({
    filters_disabled           = optional(list(string), [])
    filters_custom_definitions = optional(map(any), {})
  })
```

Default: `{}`

### <a name="input_groups_customization"></a> [groups\_customization](#input\_groups\_customization)

Description:   Customize the groups that are created by the template.

  - groups\_disabled: List of groups that should be disabled.
  - groups\_custom\_definitions: Map of custom group definitions.

Type:

```hcl
object({
    groups_disabled           = optional(list(string), [])
    groups_custom_definitions = optional(map(any), {})
  })
```

Default: `{}`

### <a name="input_homepage"></a> [homepage](#input\_homepage)

Description: Homepage URL for browsers

Type: `string`

Default: `"https://office.com"`

### <a name="input_intents_policy_customization"></a> [intents\_policy\_customization](#input\_intents\_policy\_customization)

Description:   Which macOS intent policies should be enabled or disabled?

  Give the terraform object name of the desired policy, e.g. "macos\_default\_filevault"

  - policies\_disabled: Mandatory compliance policies that should be disabled. (not recommended)

Type:

```hcl
object({
    policies_disabled = optional(list(string), [])
  })
```

Default: `{}`

### <a name="input_manage_autopilot_profiles"></a> [manage\_autopilot\_profiles](#input\_manage\_autopilot\_profiles)

Description: Should this template create Autopilot profiles?

Type: `bool`

Default: `true`

### <a name="input_manage_breakglass_account"></a> [manage\_breakglass\_account](#input\_manage\_breakglass\_account)

Description: Should this template create a breakglass account? Not recommended in most cases.

Type: `bool`

Default: `false`

### <a name="input_manage_compliance_policies"></a> [manage\_compliance\_policies](#input\_manage\_compliance\_policies)

Description: Should this template create compliance policies? Recommended for most scenarios.

Type: `bool`

Default: `true`

### <a name="input_manage_conditional_access"></a> [manage\_conditional\_access](#input\_manage\_conditional\_access)

Description: Should this template create conditional access policies?

Type: `bool`

Default: `false`

### <a name="input_manage_configuration_policies"></a> [manage\_configuration\_policies](#input\_manage\_configuration\_policies)

Description: Should this template create configuration policies ( = Settings Catalog policies)? Recommended for most scenarios.

Type: `bool`

Default: `true`

### <a name="input_manage_device_configuration"></a> [manage\_device\_configuration](#input\_manage\_device\_configuration)

Description: Should this template create device configuration policies (e.g. OMA Policies)?

Type: `bool`

Default: `true`

### <a name="input_manage_device_enrollment_configurations"></a> [manage\_device\_enrollment\_configurations](#input\_manage\_device\_enrollment\_configurations)

Description: Should this template create device enrollment configurations (ESP Page configuration)?

Type: `bool`

Default: `true`

### <a name="input_manage_filters"></a> [manage\_filters](#input\_manage\_filters)

Description: Should this template create filters? Recommended for most scenarios.

Type: `bool`

Default: `true`

### <a name="input_manage_generic_groups"></a> [manage\_generic\_groups](#input\_manage\_generic\_groups)

Description: Should this template create common groups like 'all autopilot devices' etc. These are required - if you do not use the templates, please create them manually.

Type: `bool`

Default: `true`

### <a name="input_manage_intents"></a> [manage\_intents](#input\_manage\_intents)

Description: Should this template create device management intents (e.g. FileVault, BitLocker, Defender, etc.)? Recommended for most scenarios.

Type: `bool`

Default: `true`

### <a name="input_manage_windows_feature_update_profiles"></a> [manage\_windows\_feature\_update\_profiles](#input\_manage\_windows\_feature\_update\_profiles)

Description: Should this template create Windows Feature Update Profiles?

Type: `bool`

Default: `true`

### <a name="input_windows_11_feature_update_os_version"></a> [windows\_11\_feature\_update\_os\_version](#input\_windows\_11\_feature\_update\_os\_version)

Description: Windows 11 Feature Update desired OS Version

Type: `string`

Default: `"Windows 11, version 22H2"`
<!-- END_TF_DOCS -->
