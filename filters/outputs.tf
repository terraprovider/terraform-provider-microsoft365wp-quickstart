locals {
  base_filter_resources_map = { for key, value in local.all_filters_enabled : key => {
    id           = microsoft365wp_device_and_app_management_assignment_filter.all[key].id
    display_name = microsoft365wp_device_and_app_management_assignment_filter.all[key].display_name
  } }
}


output "filters_map" {
  value = local.base_filter_resources_map
}
