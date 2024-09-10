locals {

  device_configuration_mobile_ios_ipados_default_map = {

    ios_ipados_default_latest_update = {
      display_name = "iOS/iPadOS - Default - Latest update - v1.0"
      assignments = [{
        target = local.base_target_all_devices
      }]
      ios_update = {
        update_schedule_type = "alwaysUpdate"
      }
    }

  }
}
