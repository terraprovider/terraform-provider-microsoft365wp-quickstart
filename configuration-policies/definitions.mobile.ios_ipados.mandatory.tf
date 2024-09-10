# ------------------------------------------------------------------------------
# iOS / iPadOS - Configuration Policies - Mandatory
# ------------------------------------------------------------------------------

locals {
  configuration_policy_mobile_ios_ipad_map = {

    # Just an example
    ios_ipados_default_device_restrictions = {
      assignments = [
        {
          target = local.base_target_all_users
        },
      ]
      name      = "iOS/iPadOS - Default - Simple device restrictions - v1.0"
      platforms = "iOS"
      settings = [
        {
          instance = {
            definition_id = "com.apple.applicationaccess_com.apple.applicationaccess"
            group_collection = {
              values = [
                {
                  children = [
                    {
                      choice = {
                        value = {
                          value = "com.apple.applicationaccess_allowvpncreation_false"
                        }
                      }
                      definition_id = "com.apple.applicationaccess_allowvpncreation"
                    },
                    {
                      choice = {
                        value = {
                          value = "com.apple.applicationaccess_forceairdropunmanaged_true"
                        }
                      }
                      definition_id = "com.apple.applicationaccess_forceairdropunmanaged"
                    },
                  ]
                },
              ]
            }
          }
        },
      ]
      technologies = "mdm,appleRemoteManagement"
    }
  }
}
