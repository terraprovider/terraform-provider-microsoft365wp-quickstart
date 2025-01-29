# Template for all compliance policies
resource "microsoft365wp_device_compliance_policy" "all" {
  for_each = local.all_compliance_policies_enabled

  display_name               = each.value.display_name
  assignments                = each.value.assignments
  scheduled_actions_for_rule = each.value.scheduled_actions_for_rule
  windows10                  = each.value.windows10
  macos                      = each.value.macos
  aosp_device_owner          = each.value.aosp_device_owner
  android                    = each.value.android
  android_device_owner       = each.value.android_device_owner
  android_work_profile       = each.value.android_work_profile
  ios                        = each.value.ios

  depends_on = [microsoft365wp_notification_message_template.all]
}
