locals {
  all_filters_workplace = {
    win_osversion_windows_11 = {
      display_name = "Win - osVersion - Windows 11"
      platform     = "windows10AndLater"
      rule         = "(device.osVersion -startsWith \"10.0.2\")"
    }
  }
}
