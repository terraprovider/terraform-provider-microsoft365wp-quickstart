resource "microsoft365wp_device_enrollment_configuration" "win_default_default_esp" { // will NOT update win_default_esp, but import the default ESP configuration as new object
  display_name = "###TfWorkplaceDefault###"                                           // mandatory to target default config
  priority     = 0                                                                    // mandatory to target default config
  windows10_esp = {
    allow_device_reset_on_install_failure         = false
    allow_device_use_on_install_failure           = false
    allow_log_collection_on_install_failure       = true
    block_device_setup_retry_by_user              = false
    custom_error_message                          = "Setup could not be completed. Please try again or contact your support person for help."
    disable_user_status_tracking_after_first_user = true
    install_progress_timeout_in_minutes           = 30
    show_installation_progress                    = true
    track_install_progress_for_autopilot_only     = true
  }
}
