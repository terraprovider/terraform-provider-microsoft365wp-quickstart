locals {
  # Intent assignments targets based on the configuration
  base_target_all_users   = { all_licensed_users = {} }
  base_target_all_devices = { all_devices = {} }
}

locals {

  # Configuration policies map - Workplace
  device_configuration_policies_workplace_map = merge(
    # Madatory Policies
    local.device_configuration_workplace_macos_map,
    local.device_configuration_workplace_win_map,
    # Optional Policies
    { for k, v in local.device_configuration_workplace_macos_optional_map : k => v if contains(var.policy_customization.policies_optional_enabled, k) },
    { for k, v in local.device_configuration_workplace_win_optional_map : k => v if contains(var.policy_customization.policies_optional_enabled, k) },
  )

  # Configuration policies map - Mobile
  device_configuration_policies_mobile_map = merge(
    # Mandatory Policies
    local.device_configuration_mobile_android_fm_cowp_map,
    local.device_configuration_mobile_ios_ipados_default_map,
    # Optional Policies
    { for k, v in local.device_configuration_mobile_android_fully_cowp_optional_map : k => v if contains(var.policy_customization.policies_optional_enabled, k) },
    { for k, v in local.device_configuration_mobile_ios_ipados_default_optional_map : k => v if contains(var.policy_customization.policies_optional_enabled, k) },
  )

  # Merge all the policies
  device_configuration_policies_merged = merge(
    { for k, v in local.device_configuration_policies_workplace_map : k => v if var.enable_workplace },
    { for k, v in local.device_configuration_policies_mobile_map : k => v if var.enable_mobile },
    # Include custom policies
    var.policy_customization.policies_custom_definitions
  )

  # Use presets to filter out policies
  device_configuration_policies_disabled_list = distinct(concat(
    # Disable base policies (emergency cases or testing)
    local.base_disabled_policies_list,
    # Disable custom policies
    var.policy_customization.policies_disabled
  ))

  # Filter keys that are not in the disabled_policies list
  device_configuration_policies_filtered_map = { for k, v in local.device_configuration_policies_merged : k => v
    if !contains(local.device_configuration_policies_disabled_list, k)
  }

  # Map the policies to the format required by the API (Note this is not a base map)

  device_configuration_policies_map = { for key, value in local.device_configuration_policies_filtered_map : key =>
    {
      display_name = format("%s%s%s", var.displayname_prefix, value.display_name, var.displayname_suffix)
      description  = try(value.description, null)

      assignments = concat(
        [for a in try(value.assignments, []) : {
          target = {
            all_devices        = try(a.target.all_devices, null) != null ? a.target.all_devices : null,
            all_licensed_users = try(a.target.all_licensed_users, null) != null ? a.target.all_licensed_users : null,
            exclusion_group = try(a.target.exclusion_group, null) != null ? {
              group_id = a.target.exclusion_group.group_id
            } : null,
            filter_id   = try(a.target.filter_id, null)
            filter_type = try(a.target.filter_type, null)
            group = try(a.target.group, null) != null ? {
              group_id = a.target.group.group_id
            } : null
          }
        }],

      )

      # All properties are optional
      android_device_owner_general_device = try(value.android_device_owner_general_device, null)

      device_management_applicability_rule_device_mode = try(value.device_management_applicability_rule_device_mode, {}) != {} ? {
        device_mode = value.device_management_applicability_rule_device_mode.device_mode
        rule_type   = value.device_management_applicability_rule_device_mode.rule_type
        name        = try(value.device_management_applicability_rule_device_mode.name, null)
      } : null

      device_management_applicability_rule_os_edition = try(value.device_management_applicability_rule_os_edition, {}) != {} ? {
        os_edition_types = value.device_management_applicability_rule_os_edition.os_edition_types
        rule_type        = value.device_management_applicability_rule_os_edition.rule_type
        name             = try(value.device_management_applicability_rule_os_edition.name, null)
      } : null

      device_management_applicability_rule_os_version = try(value.device_management_applicability_rule_os_version, {}) != {} ? {
        rule_type      = value.device_management_applicability_rule_os_edition.rule_type
        max_os_version = try(value.device_management_applicability_rule_os_edition.max_os_version, null)
        min_os_version = try(value.device_management_applicability_rule_os_edition.min_os_version, null)
        name           = try(value.device_management_applicability_rule_os_edition.name, null)
      } : null

      ios_custom = try(value.ios_custom, {}) != {} ? {
        file_name = value.ios_custom.file_name
        name      = value.ios_custom.name
        payload   = value.ios_custom.payload
      } : null

      # All properties are optional
      ios_device_features = try(value.ios_device_features, null)

      ios_eas_email_profile = try(value.ios_eas_email_profile, {}) != {} ? {
        account_name                                  = value.ios_eas_email_profile.account_name
        email_address_source                          = value.ios_eas_email_profile.email_address_source
        host_name                                     = value.ios_eas_email_profile.host_name
        authentication_method                         = try(value.ios_eas_email_profile.authentication_method, null)
        block_moving_messages_to_other_email_accounts = try(value.ios_eas_email_profile.block_moving_messages_to_other_email_accounts, null)
        block_sending_email_from_third_party_apps     = try(value.ios_eas_email_profile.block_sending_email_from_third_party_apps, null)
        block_syncing_recently_used_email_addresses   = try(value.ios_eas_email_profile.block_syncing_recently_used_email_addresses, null)
        custom_domain_name                            = try(value.ios_eas_email_profile.custom_domain_name, null)
        duration_of_email_to_sync                     = try(value.ios_eas_email_profile.duration_of_email_to_sync, null)
        eas_services                                  = try(value.ios_eas_email_profile.eas_services, null)
        eas_services_user_override_enabled            = try(value.ios_eas_email_profile.eas_services_user_override_enabled, null)
        encryption_certificate_type                   = try(value.ios_eas_email_profile.encryption_certificate_type, null)
        per_app_vpn_profile_id                        = try(value.ios_eas_email_profile.per_app_vpn_profile_id, null)
        require_ssl                                   = try(value.ios_eas_email_profile.require_ssl, null)
        signing_certificate_type                      = try(value.ios_eas_email_profile.signing_certificate_type, null)
        use_oauth                                     = try(value.ios_eas_email_profile.use_oauth, null)
        user_domain_name_source                       = try(value.ios_eas_email_profile.user_domain_name_source, null)
        username_aad_source                           = try(value.ios_eas_email_profile.username_aad_source, null)
        username_source                               = try(value.ios_eas_email_profile.username_source, null)
      } : null

      # All properties are optional
      ios_general_device = try(value.ios_general_device, null)

      # All properties are optional
      ios_update = try(value.ios_update, null)

      ios_vpn = try(value.ios_vpn, {}) != {} ? {
        authentication_method = value.ios_vpn.authentication_method
        connection_name       = value.ios_vpn.connection_name
        connection_type       = value.ios_vpn.connection_type
        server = {
          address           = value.ios_vpn.server.address
          description       = try(value.ios_vpn.server.description, null)
          is_default_server = try(value.ios_vpn.server.is_default_server, null)
        }
        associated_domains                  = try(value.ios_vpn.associated_domains, null)
        cloud_name                          = try(value.ios_vpn.cloud_name, null)
        custom_data                         = try(value.ios_vpn.custom_data, null)
        disable_on_demand_user_override     = try(value.ios_vpn.disable_on_demand_user_override, null)
        disconnect_on_idle                  = try(value.ios_vpn.disconnect_on_idle, null)
        disconnect_on_idle_timer_in_seconds = try(value.ios_vpn.disconnect_on_idle_timer_in_seconds, null)
        enable_per_app                      = try(value.ios_vpn.enable_per_app, null)
        enable_split_tunneling              = try(value.ios_vpn.enable_split_tunneling, null)
        exclude_list                        = try(value.ios_vpn.exclude_list, null)
        excluded_domains                    = try(value.ios_vpn.excluded_domains, null)
        identifier                          = try(value.ios_vpn.identifier, null)
        login_group_or_domain               = try(value.ios_vpn.login_group_or_domain, null)
        microsoft_tunnel_site_id            = try(value.ios_vpn.microsoft_tunnel_site_id, null)
        on_demand_rules                     = try(value.ios_vpn.on_demand_rules, null)
        opt_in_to_device_id_sharing         = try(value.ios_vpn.opt_in_to_device_id_sharing, null)
        provider_type                       = try(value.ios_vpn.provider_type, null)
        proxy_server                        = try(value.ios_vpn.proxy_server, null)
        realm                               = try(value.ios_vpn.realm, null)
        role                                = try(value.ios_vpn.role, null)
        safari_domains                      = try(value.ios_vpn.safari_domains, null)
        strict_enforcement                  = try(value.ios_vpn.strict_enforcement, null)
        targeted_mobile_apps                = try(value.ios_vpn.targeted_mobile_apps, null)
        user_domain                         = try(value.ios_vpn.user_domain, null)
      } : null

      macos_custom = try(value.macos_custom, {}) != {} ? {
        deployment_channel = value.macos_custom.deployment_channel
        file_name          = value.macos_custom.file_name
        name               = value.macos_custom.name
        payload            = value.macos_custom.payload
      } : null

      macos_custom_app = try(value.macos_custom_app, {}) != {} ? {
        bundle_id         = value.macos_custom_app.bundle_id
        file_name         = value.macos_custom_app.file_name
        configuration_xml = value.macos_custom_app.configuration_xml
      } : null

      # All properties are optional
      macos_device_features = try(value.macos_device_features, null)

      # All properties are optional
      macos_extensions = try(value.macos_extensions, null)

      # All properties are optional
      macos_software_update = try(value.macos_software_update, null)

      # All properties are optional
      role_scope_tag_ids = try(value.role_scope_tag_ids, null)

      # All properties are optional
      windows_health_monitoring = try(value.windows_health_monitoring, null)

      # All properties are optional
      windows_update_for_business = try(value.windows_update_for_business, null)

      # ---------------------------------------------------------------------------
      # Resource: workplace_device_configuration_custom

      # All properties are optional
      windows10 = try(value.windows10, null)
    }
  }

  # Base maps for the device configuration policies

  base_device_configuration_policies_map        = { for key, value in local.device_configuration_policies_map : key => value if value.windows10 == null }
  base_device_configuration_policies_custom_map = { for key, value in local.device_configuration_policies_map : key => value if value.windows10 != null }
}
