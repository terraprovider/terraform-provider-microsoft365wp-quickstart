locals {
  all_filters_merged = merge(
    { for k, v in local.all_filters_workplace : k => v if var.include_workplace },
    { for k, v in local.all_filters_mobile : k => v if var.include_mobile },
    { for k, v in local.all_filters_exported : k => v },
    # Include custom policies
    var.filters_customization.filters_custom_definitions
  )

  base_all_filters = { for key, value in local.all_filters_merged : key => {
    display_name = format("%s%s%s", var.displayname_prefix, value.display_name, var.displayname_suffix)
    platform     = value.platform
    rule         = value.rule
    description  = try(value.description, "")
  } }

  # If you have more logic to disable filters, you can add it here
  all_filters_disabled = distinct(concat(
    var.filters_customization.filters_disabled,
  ))

  all_filters_enabled = { for k, v in local.base_all_filters : k => v
    if !contains(local.all_filters_disabled, k)
  }
}
