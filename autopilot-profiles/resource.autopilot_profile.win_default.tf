resource "microsoft365wp_azure_ad_windows_autopilot_deployment_profile" "win_default" {
  device_name_template             = "${var.client_prefix}%SERIAL%"
  device_type                      = "windowsPc"
  display_name                     = "Win_Default"
  preprovisioning_allowed          = true
  hardware_hash_extraction_enabled = false
  locale                           = "os-default"
  out_of_box_experience_setting = {
    device_usage_type               = "singleUser"
    escape_link_hidden              = true
    eula_hidden                     = true
    keyboard_selection_page_skipped = false
    privacy_settings_hidden         = true
    user_type                       = "standard"
  }
}
