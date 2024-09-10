# aad2tf.ps1

- Set environment variables for Azure authentication, usually done through a `.env` like this: `. ./.env`
- Run `terraform init`
- Import resources, for example (change guid to match your real resource):
  - `./aad2tf.ps1 microsoft365wp_device_configuration_custom 44cdc9bf-6467-4252-bc71-21e99ed2e69f`
  - `./aad2tf.ps1 microsoft365wp_device_management_configuration_policy fe3bd7eb-d7c2-42d5-ba32-6d5ee27ced57`
  - `./aad2tf.ps1 microsoft365wp_device_management_configuration_policy 06e5889d-2f86-41c9-9f60-5bbf2a1f70f9`
- Run `terraform plan` to see if configuration matches the resources.
