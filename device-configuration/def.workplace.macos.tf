locals {

  device_configuration_workplace_macos_map = {

    macos_default_update_policies = {
      assignments = [
        {
          target = local.base_target_all_devices
        },
      ]
      display_name = "macOS - Default - Update policies - v3.0"
      macos_software_update = {
        all_other_update_behavior   = "installLater"
        config_data_update_behavior = "installLater"
        critical_update_behavior    = "installLater"
        firmware_update_behavior    = "installLater"
        max_user_deferrals_count    = 5
        priority                    = "high"
        update_schedule_type        = "alwaysUpdate"
      }
    }

  }
}
