locals {
  all_filters_mobile = {
    ios_ipados_osversion_16_x = {
      display_name = "iOS/iPadOS - osVersion - 16.x"
      platform     = "iOS"
      rule         = "(device.osVersion -startsWith \"16.\")"
    }
  }
}
