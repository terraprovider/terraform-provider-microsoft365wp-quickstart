# ------------------------------------------------------------------------------
# Notification message templates
# ------------------------------------------------------------------------------

locals {

  # Create a base map of resource group definitions

  def_notification_message_template_map = { for key, item in local.def_notification_message_templates_exported : key =>
    {
      display_name     = format("%s%s%s", var.displayname_prefix, item.display_name, var.displayname_suffix)
      branding_options = try(item.branding_options, null)
      localized_notification_messages = [for localized_item in item.localized_notification_messages :
        {
          locale           = localized_item.locale
          subject          = localized_item.subject
          message_template = localized_item.message_template
          is_default       = try(localized_item.is_default, null)
        }
      ]
    }
  }

}
