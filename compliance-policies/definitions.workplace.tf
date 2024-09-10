locals {

  # List of all (non-optional) compliance policies for workplace
  all_compliance_policies_workplace = {

    win_default_device_health_bitlocker = {
      display_name = "Win - Default - Device Health - BitLocker - v1.0"
      scheduled_actions_for_rule = [
        {
          scheduled_action_configurations = [
            {
              action_type              = "block"
              grace_period_hours       = 12
              notification_template_id = "00000000-0000-0000-0000-000000000000"
            },
          ]
        },
      ]
      windows10 = {
        bitlocker_enabled = true
        tpm_required      = true
      }
    }

    macos_default_system_security_encryption = {
      display_name = "macOS - Default - System Security - Encryption - v1.0"
      scheduled_actions_for_rule = [
        {
          scheduled_action_configurations = [
            {
              action_type              = "block"
              grace_period_hours       = 12
              notification_template_id = "00000000-0000-0000-0000-000000000000"
            },
          ]
        },
      ]
      macos = {
        storage_require_encryption = true
      }
    }

    macos_default_system_security = {
      display_name = "macOS - Default - System Security - v1.0"
      scheduled_actions_for_rule = [
        {
          scheduled_action_configurations = [
            {
              action_type              = "block"
              grace_period_hours       = 0
              notification_template_id = "00000000-0000-0000-0000-000000000000"
            },
          ]
        },
      ]
      macos = {
        firewall_enabled = true
      }
    }
  }

  # Optional compliance policies. These can be enabled via var.compliance_policies_customization
  all_compliance_policies_workplace_optional = {

  }
}

