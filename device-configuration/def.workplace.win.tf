locals {

  device_configuration_workplace_win_map = {

    win_default_update_ring_gac_1 = {
      assignments = [
        {
          target = local.base_target_all_users
        },
      ]
      display_name = "Win - Default - Update ring - GAC 1 - v1.0"
      windows_update_for_business = {
        allow_windows11_upgrade                 = false
        auto_restart_notification_dismissal     = "notConfigured"
        automatic_update_mode                   = "autoInstallAtMaintenanceTime"
        business_ready_updates_only             = "userDefined"
        deadline_for_feature_updates_in_days    = 2
        deadline_for_quality_updates_in_days    = 1
        deadline_grace_period_in_days           = 1
        delivery_optimization_mode              = "userDefined"
        drivers_excluded                        = false
        feature_updates_deferral_period_in_days = 6
        feature_updates_paused                  = false
        feature_updates_rollback_window_in_days = 30
        installation_schedule = {
          active_hours = {
            end   = "17:00:00.0000000"
            start = "08:00:00.0000000"
          }
        }
        microsoft_update_service_allowed        = true
        postpone_reboot_until_after_deadline    = true
        prerelease_features                     = "userDefined"
        quality_updates_deferral_period_in_days = 2
        quality_updates_paused                  = false
        skip_checks_before_restart              = false
        update_notification_level               = "defaultNotifications"
        user_pause_access                       = "disabled"
        user_windows_update_scan_access         = "enabled"
      }
    }
  }
}
