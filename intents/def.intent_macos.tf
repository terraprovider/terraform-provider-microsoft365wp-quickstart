locals {
  all_device_management_intents_macos = {

    macos_default_firewall = {
      assignments  = [local.target_all_user]
      display_name = "macOS - Default - Firewall - v1.0"
      settings = [
        {
          boolean = {
            value = var.macos_firewall.block_all_incoming
          }
          definition_id = "deviceConfiguration--macOSEndpointProtectionConfiguration_firewallBlockAllIncoming"
        },
        {
          boolean = {
            value = var.macos_firewall.enable_stealth
          }
          definition_id = "deviceConfiguration--macOSEndpointProtectionConfiguration_firewallEnableStealthMode"
        },
        {
          boolean = {
            value = true
          }
          definition_id = "deviceConfiguration--macOSEndpointProtectionConfiguration_firewallEnabled"
        },
        {
          collection = {
            value_json = "null"
          }
          definition_id = "deviceConfiguration--macOSEndpointProtectionConfiguration_firewallApplications"
        },
      ]
      template_id = "5340aa10-47a8-4e67-893f-690984e4d5da"
    }

  }
}
