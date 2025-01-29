
# ------------------------------------------------------------------------------
# Notification message templates
# ------------------------------------------------------------------------------

resource "microsoft365wp_notification_message_template" "all" {
  for_each = local.def_notification_message_template_map

  display_name     = each.value.display_name
  branding_options = each.value.branding_options

  localized_notification_messages = each.value.localized_notification_messages
}
