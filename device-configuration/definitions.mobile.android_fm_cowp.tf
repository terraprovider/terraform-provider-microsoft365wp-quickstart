locals {

  # Android - Fully Managed / Corporate-Owned Work Profile 
  device_configuration_mobile_android_fm_cowp_map = {

    android_fully_cowp_default_device_restrictions = {
      display_name = "Android - CoWP - Default - Device Restrictions - v1.0"

      assignments = [{
        target = local.base_target_all_devices
      }]

      android_device_owner_general_device = {
        # System Security
        security_require_verify_apps = true
        # Device Password
        password_required_type                              = "numericComplex"
        password_minimum_length                             = 6
        password_sign_in_failure_count_before_factory_reset = 10
        password_block_keyguard_features = [
          "face",
          "iris",
          "trustAgents",
        ]
      }
    }
  }
}
