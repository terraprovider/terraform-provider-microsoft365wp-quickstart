# ------------------------------------------------------------------------------
# Workplace - Windows configuration policies - Mandatory
# ------------------------------------------------------------------------------

locals {
  configuration_policy_workplace_win_map = {

    win_default_bitlocker = {
      assignments = [
        {
          target = local.base_target_all_devices
        },
      ]
      name      = "Win - Default - Simple BitLocker - v1.0"
      platforms = "windows10"
      settings = [
        {
          instance = {
            choice = {
              value = {
                template_reference = {
                  id          = "86da5fa5-67cf-48d1-8215-8787a9900ae6"
                  use_default = false
                }
                value = "device_vendor_msft_bitlocker_requiredeviceencryption_1"
              }
            }
            definition_id = "device_vendor_msft_bitlocker_requiredeviceencryption"
            template_reference = {
              id = "20ec1f6e-0d7a-4b6f-9a4f-9ed33e69ce51"
            }
          }
        },
      ]
      technologies = "mdm"
      template_reference = {
        id = "46ddfc50-d10f-4867-b852-9434254b3bff_1"
      }
    }
  }
}
