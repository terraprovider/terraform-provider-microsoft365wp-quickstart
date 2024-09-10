locals {

  # Targeting configuration
  all_users_target   = { all_licensed_users = {} }
  all_devices_target = { all_devices = {} }

  # Intent assignments targets based on the configuration
  target_all_user = {
    target = local.all_users_target
  }
  target_all_device = {
    target = local.all_devices_target
  }
}

locals {

  # Enable / disable specific intents based on the configuration
  all_device_management_intents_merged = merge(
    { for key, value in local.all_device_management_intents_macos : key => value if var.enable_workplace && !contains(var.policy_customization.policies_disabled, key) }
  )

  # Base device management intents
  base_all_device_management_intents = { for key, value in local.all_device_management_intents_merged : key => {
    display_name = format("%s%s%s", var.displayname_prefix, value.display_name, var.displayname_suffix)
    assignments  = value.assignments
    settings     = value.settings
    template_id  = value.template_id
  } }
}
