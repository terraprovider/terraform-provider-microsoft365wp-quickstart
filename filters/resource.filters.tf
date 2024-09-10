resource "microsoft365wp_device_and_app_management_assignment_filter" "all" {
  for_each = local.all_filters_enabled

  display_name = each.value.display_name
  platform     = each.value.platform
  rule         = each.value.rule
}
