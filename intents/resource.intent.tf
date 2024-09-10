resource "microsoft365wp_device_management_intent" "all" {
  for_each = local.base_all_device_management_intents

  display_name = each.value.display_name
  assignments  = each.value.assignments
  settings     = each.value.settings
  template_id  = each.value.template_id
}
