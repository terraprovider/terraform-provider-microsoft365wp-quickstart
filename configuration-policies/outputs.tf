# ------------------------------------------------------------------------------
# Outputs
# ------------------------------------------------------------------------------

# Show disabled policies

output "disabled_policies" {
  value = [for k, v in local.device_configuration_policies_merged : k if contains(local.device_configuration_policies_disabled_list, k)]
}
