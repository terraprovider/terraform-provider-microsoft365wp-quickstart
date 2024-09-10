resource "azuread_group" "all_devices_win11_pilot" {
  display_name     = "${var.displayname_prefix}CFG - Devices - Win11 Pilot Devices${var.displayname_suffix}"
  mail_enabled     = false
  security_enabled = true
}
