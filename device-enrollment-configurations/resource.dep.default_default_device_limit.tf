resource "microsoft365wp_device_enrollment_configuration" "default_default_device_limit" { // will NOT update win_default_esp, but import the default ESP configuration as new object
  display_name = "###TfWorkplaceDefault###"                                                // mandatory to target default config
  priority     = 0                                                                         // mandatory to target default config
  device_enrollment_limit = {
    limit = var.device_enrollment_limit
  }
}
