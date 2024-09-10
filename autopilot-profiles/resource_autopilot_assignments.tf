resource "microsoft365wp_azure_ad_windows_autopilot_deployment_profile_assignment" "win_default_assignment" {
  azure_ad_windows_autopilot_deployment_profile_id = microsoft365wp_azure_ad_windows_autopilot_deployment_profile.win_default.id
  target                                           = local.all_autopilot_devices_target
}
