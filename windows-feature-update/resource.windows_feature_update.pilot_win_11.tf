resource "microsoft365wp_windows_feature_update_profile" "win_default_feature_update_pilot_win_11" {
  count = var.enable_workplace ? 1 : 0
  assignments = [
    {
      target = {
        group = {
          group_id = azuread_group.all_devices_win11_pilot.id
        }
      }
    },
  ]
  display_name                                            = "${var.displayname_prefix}Win - Default - Feature Update - Pilot Win 11${var.displayname_suffix}"
  feature_update_version                                  = var.windows_11_feature_update_os_version
  install_latest_windows10_on_windows11_ineligible_device = false
  rollout_settings                                        = {}
  description                                             = ""
}
