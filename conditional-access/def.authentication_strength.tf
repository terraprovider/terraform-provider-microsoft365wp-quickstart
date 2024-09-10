locals {
  all_authentications_strength_policies = {
    fido = {
      display_name = "FIDO"
      allowed_combinations = [
        "fido2",
      ]
    }
  }
}
