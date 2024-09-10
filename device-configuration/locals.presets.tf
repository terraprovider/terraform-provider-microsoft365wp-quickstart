# ------------------------------------------------------------------------------
# Predefined presets for the configuration policies
# ------------------------------------------------------------------------------

locals {
  managed_favorites_edge_macos_filepath = format("%s/assets/macos.edge.favorites.xml", path.root)
  managed_favorites_edge_macos_xml      = fileexists(local.managed_favorites_edge_macos_filepath) ? file(local.managed_favorites_edge_macos_filepath) : ""
}

locals {

  # Hardcoded list of policies that can be disabled only by disabling the whole policy (i.e. have only one setting)
  # Also for emergency cases or testing.
  base_disabled_policies_list = concat(
    # Policy disabled by switch in the configuration

    ## Using keys() + only one poliycy seems to expand the properties of the policy instead of giving its name. 
    #local.managed_favorites_edge_macos_xml != "" ? null : local.device_configuration_workplace_macos_map.macos_default_edge_managed_favorites,

    local.managed_favorites_edge_macos_xml != "" ? [] : ["macos_default_edge_managed_favorites"],
  )

  # Which policies should be disabled if defender is missing
  base_defender_policies_preset_list = [

    # Windows

    # macOS
    ## Using keys() + only one poliycy seems to expand the properties of the policy instead of giving its name. 
    #local.device_configuration_workplace_macos_map.macos_default_defender_onboarding,
    "macos_default_defender_onboarding",
  ]

  # Due to the limitation of resource, we need to ignore settings in the lifecycle block

  lifecycle_ignore_settings_json = keys({})

}
