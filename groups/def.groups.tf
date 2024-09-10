# ------------------------------------------------------------------------------
# EntraID Groups - definitions
# ------------------------------------------------------------------------------

locals {
  azuread_groups_definitions_map = {

    all_autopilot_device = {
      display_name            = var.all_autopilot_device_group_name
      dynamic_membership      = true
      dynamic_membership_rule = "(device.devicePhysicalIDs -any _ -contains \"[ZTDId]\")"
    }
  }
}
