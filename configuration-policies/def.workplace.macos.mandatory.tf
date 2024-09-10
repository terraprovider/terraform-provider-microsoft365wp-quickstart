# ------------------------------------------------------------------------------
# Workplace - macOS configuration policies - Mandatory
# ------------------------------------------------------------------------------

locals {
  configuration_policy_workplace_macos_map = {

    macos_default_apple_software_update = {
      assignments = [
        {
          target = local.base_target_all_devices
        },
      ]
      name      = "macOS - Default - Apple Software Update - v5.0"
      platforms = "macOS"
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
                          value = "com.apple.applicationaccess_allowrapidsecurityresponseremoval_false"
                        }
                      }
                      definition_id = "com.apple.applicationaccess_allowrapidsecurityresponseremoval"
                    },
                  ]
                },
              ]
            }
          }
        },
        {
          instance = {
            definition_id = "com.apple.softwareupdate_com.apple.softwareupdate"
            group_collection = {
              values = [
                {
                  children = [
                    {
                      choice = {
                        value = {
                          value = "com.apple.softwareupdate_automaticcheckenabled_true"
                        }
                      }
                      definition_id = "com.apple.softwareupdate_automaticcheckenabled"
                    },
                    {
                      choice = {
                        value = {
                          value = "com.apple.softwareupdate_automaticdownload_true"
                        }
                      }
                      definition_id = "com.apple.softwareupdate_automaticdownload"
                    },
                    {
                      choice = {
                        value = {
                          value = "com.apple.softwareupdate_automaticallyinstallappupdates_true"
                        }
                      }
                      definition_id = "com.apple.softwareupdate_automaticallyinstallappupdates"
                    },
                    {
                      choice = {
                        value = {
                          value = "com.apple.softwareupdate_automaticallyinstallmacosupdates_true"
                        }
                      }
                      definition_id = "com.apple.softwareupdate_automaticallyinstallmacosupdates"
                    },
                    {
                      choice = {
                        value = {
                          value = "com.apple.softwareupdate_configdatainstall_true"
                        }
                      }
                      definition_id = "com.apple.softwareupdate_configdatainstall"
                    },
                    {
                      choice = {
                        value = {
                          value = "com.apple.softwareupdate_criticalupdateinstall_true"
                        }
                      }
                      definition_id = "com.apple.softwareupdate_criticalupdateinstall"
                    },
                    {
                      choice = {
                        value = {
                          value = "com.apple.softwareupdate_restrict-software-update-require-admin-to-install_false"
                        }
                      }
                      definition_id = "com.apple.softwareupdate_restrict-software-update-require-admin-to-install"
                    },
                  ]
                },
              ]
            }
          }
        },
      ]
      technologies = "mdm"
    }

    macos_default_edge_home_and_start_page = {
      assignments = [
        {
          target = local.base_target_all_users
        },
      ]
      name      = "macOS - Default - Edge - Simple Home Page - v1.0"
      platforms = "macOS"
      settings = concat(
        [
          {
            instance = {
              definition_id = "com.apple.managedclient.preferences_homepagelocation"
              simple = {
                value = {
                  string = {
                    value = var.homepage
                  }
                }
              }
            }
          },
        ],
      )
      technologies = "mdm,appleRemoteManagement"
    }
  }
}
