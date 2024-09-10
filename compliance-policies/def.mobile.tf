locals {

  all_compliance_policies_mobile = {

    ios_ipados_default_device_properties_16_x = {
      display_name = "iOS/iPadOS - Default - Device Properties - 16.x - v1.0"
      filter_id    = var.filters_map.ios_ipados_osversion_16_x.id
      filter_type  = "include"
      ios = {
        os_minimum_version = var.compliance_ios_ipad_16_os_min_os_version
      }
      scheduled_actions_for_rule = [
        {
          scheduled_action_configurations = [
            {
              action_type              = "block"
              grace_period_hours       = 120
              notification_template_id = "00000000-0000-0000-0000-000000000000"
            },
            {
              action_type              = "pushNotification"
              grace_period_hours       = 0
              notification_template_id = "00000000-0000-0000-0000-000000000000"
            },
            {
              action_type              = "pushNotification"
              grace_period_hours       = 72
              notification_template_id = "00000000-0000-0000-0000-000000000000"
            }
          ]
        }
      ]
    }


    ios_ipados_default_system_security = {
      display_name = "iOS/iPadOS - Default - System Security - v1.0"
      ios = {
        passcode_required                 = true
        passcode_block_simple             = true
        passcode_minimum_length           = 6
        security_block_jailbroken_devices = true
      }
      target_group = "all_users"
      scheduled_actions_for_rule = [
        {
          scheduled_action_configurations = [
            {
              action_type        = "block"
              grace_period_hours = 0
            },
            {
              action_type        = "pushNotification"
              grace_period_hours = 0
            }
          ]
        }
      ]
    }
  }

  # Optional compliance policies. These can be enabled via var.compliance_policies_customization
  all_compliance_policies_mobile_optional = {
  }
}
