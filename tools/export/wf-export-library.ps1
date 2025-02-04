function Invoke-MGGraphRequestAll {
    param(
        [string]$Uri,
        [System.Collections.ArrayList]$result
    )

    $response = invoke-mggraphRequest -Uri $Uri
    $result += $response.value
    while ($response."@odata.nextLink") {
        $response = invoke-mggraphRequest -Uri $response."@odata.nextLink"
        $result += $response.value
    }
    return $result
}

function build-name {
    param(
        [string]$name
    )
    $name = $name -Replace (" ", "_")
    $name = $name -Replace ("_[-=]_", "_")
    $name = $name -Replace ("[-/]", "_")
    $name = $name -Replace ('_v\d+(\.\d+)*', '') # remove version number
    $name = $name -Replace ("\.", "_")
    $name = $name -Replace ('[(),&%]', '')
    $name = $name -Replace ("__", "_")
    return $name.ToLower()
}

function Generate-TFConfig {
    param (
        [string]$resourceType,
        [string]$importId,
        [string]$resourceName,
        [string]$terraformExecutable = "tofu",
        [string]$outPath,
        [switch]$initUpgrade,
        [switch]$debug
    )

    $tempTfDir = [IO.Path]::Combine((Get-Location), ".aad2tf-tmp")
    New-Item -ItemType Directory -Force $tempTfDir | Out-Null
    $tempTfAllTf = [IO.Path]::Combine($tempTfDir, "*.tf")
    if (Test-Path $tempTfAllTf) { Remove-Item $tempTfAllTf }

    $tempTfFileImport = [IO.Path]::Combine($tempTfDir, "import.tf")
    $tempTfFileGenerated = [IO.Path]::Combine($tempTfDir, "generated.tf")

    @"
terraform {
  required_providers {
    microsoft365wp = {
      source = "terraprovider/microsoft365wp"
    }
    azuread = {
      source = "hashicorp/azuread"
    }
  }
}

import {
    to = ${resourceType}.${resourceName}
    id = "${importId}"
}
"@ | Out-File $tempTfFileImport -Encoding utf8NoBOM

    # this may print an error that we can just ignore
    try {
        if ($initUpgrade -or -not (Test-Path ([IO.Path]::Combine($tempTfDir, ".terraform", "providers", "tfp-c4a8-workplace.c4a8.io", "c4a8", "workplace")))) {
            & $terraformExecutable "-chdir=$tempTfDir" init -upgrade
        }
        & $terraformExecutable "-chdir=$tempTfDir" plan "-generate-config-out=$tempTfFileGenerated"
    }
    catch {
        if (-not(Test-Path $tempTfFileGenerated)) { throw }
        Write-Host "#`n# Terraform threw an error, but it is very likely that this can just be ignored since it did generate the configuration.`n#"
    }

    $result = Get-Content -Raw $tempTfFileGenerated

    # some general replacements
    $result = $result -replace '(?im)^\s*\n', '' # empty lines
    $result = $result -replace '(?im)^#.*?\n', '' # comments
    $result = $result -replace '(?im)^.*=\s*null\n', '' # null values
    $result = $result -replace '(?im)^\s*\w+\s*=\s*\[\s*\]\n', '' # empty arrays
    # we can only remove specific empty maps to not remove empty nested derived types (e.g. all_devices = {})
    $result = $result -replace '(?im)=\s*\{\s*\}', '= {}' # convert empty maps to single line
    $result = $result -replace '(?im)^\s*role_scope_tag_ids\s*=\s*\[\s*"0"\s*\]\n', ''
    $result = $result -replace '(?im)^\s*role_scope_tags\s*=\s*\[\s*"0"\s*\]\n', ''
    $result = $result -replace '(?im)^\s*filter_type\s*=\s*"none"\s*\n', ''

    # custom replacements for a few resource types
    switch ($resourceType) {
        "microsoft365wp_device_management_configuration_policy" {
            $result = $result -replace '(?im)^\s*template_reference\s*=\s*\{[\n\s]*\}\n', '' # empty template_reference
        }
    }

    # format to remove extra spaces
    $result = $result | & $terraformExecutable fmt -

    if (-not $outPath) {
        $outPath = "${resourceType}_${resourceName}.tf"
    }
    $result | Out-File $outPath -Encoding utf8NoBOM

    Write-Host
    Write-Host "###"
    Write-Host "### Completed successfully, result added to $outPath"
    Write-Host "###"
}

function Export-EntraIDGroups {
    param (
        $moduleFolder = "groups",
        $localsFileName = "def.groups.exported.tf",
        $tfLocalsName = "azuread_groups_exported_map",
        $mappingFileName = "mappings.groups.json",
        $tfExecutable = "tofu",
        [switch]$overwrite = $false
    )

    $groups = Invoke-MGGraphRequestAll -Uri 'https://graph.microsoft.com/v1.0/groups?$select=id,mailEnabled,securityEnabled,membershipRule,mailNickname,displayName,description,groupTypes'

    if (-not $overwrite) {
        if (Test-Path $moduleFolder/$localsFileName) {
            "## File $moduleFolder/$localsFileName already exists."
            throw "File $moduleFolder/$localsFileName already exists."
        }
        if (Test-Path $mappingFileName) {
            "## File $mappingFileName already exists."
            throw "File $mappingFileName already exists."
        }
    }

    $tfGroupMapping = @{
    }

    # Make sure directories exist
    if (-not (Test-Path $moduleFolder)) { New-Item -ItemType Directory -Path $moduleFolder }
    if (-not (Test-Path "$moduleFolder/json")) { New-Item -ItemType Directory -Path "$moduleFolder/json" }

    @"
# -------------------------------------------------------------------------------
# Entra ID Groups - File exported via script 'tools/export/wf-export-library.ps1'
# -------------------------------------------------------------------------------

locals {
  $($tfLocalsName) = {

"@ | Set-Content -Path $moduleFolder/$localsFileName

    foreach ($group in $groups) {
        #$groupTFObject = $group | Select-Object -Property mailEnabled, securityEnabled, membershipRule, displayName, description, groupTypes
        $groupTfName = build-name -name $group.displayName
        # $tfGroupsExport[$groupTfName] = $groupTFObject
        # Check that the mapping does not already contain the id or GroupTFName
        if ($tfGroupMapping.ContainsKey($group.id) -or $tfGroupMapping.ContainsValue($groupTfName)) {
            "## Group ID or GroupTFName already exists in the mapping."
            "## Group ID: $($group.id)"
            "## GroupTFName: $groupTfName"
            throw "Group ID or GroupTFName already exists in the mapping."
        }
        $tfGroupMapping[$group.id] = $groupTfName

        # Create a raw JSON export as backup
        $group | ConvertTo-Json -Depth 100 | Set-Content -Path "$moduleFolder/json/$groupTfName.json"

        Generate-TFConfig -resourceType "azuread_group" -importId "/groups/$($group.id)" -resourceName $groupTfName -outPath "exportedGroup.tf" -terraformExecutable $tfExecutable

        $tfTemplate = (Get-Content -Path "exportedGroup.tf") -replace "resource `"azuread_group`" `".*`" {", "$($groupTfName) = {"

        # Remove unneeded or unsupported attributes
        $attributesToRemove = @("owners", "members", "mail_nickname", "onpremises_group_type", "visibility" )
        foreach ($attribute in $attributesToRemove) {
            "## replacing $attribute"
            $tfTemplate = $tfTemplate -replace "(?im)^\s*$attribute\s*=\s*.*$", ''
        }

        # Handle dynamic memberships
        $tfTemplate = $tfTemplate -replace "(?im)^  dynamic_membership\s*{\s*$", ''
        $tfTemplate = $tfTemplate -replace "(?im)^    enabled\s*=\s*(true|false)\s*$", '  dynamic_membership = $1'
        $tfTemplate = $tfTemplate -replace "(?im)^    rule\s*=\s*(.*)$", '  dynamic_membership_rule = $1'
        $tfTemplate = $tfTemplate -replace "(?im)^  }.*$", ''

        # Warn if tfTemplate is contains a unique identifier (that is not resolved)
        if ($tfTemplate -match "[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}") {
            "## Found a unique identifier in $groupTfName that is not resolved." >> log.txt
        }

        # Remove empty lines
        $tfTemplate = $tfTemplate | Where-Object { $_ -ne "" }

        $tfTemplate | Add-Content -Path $moduleFolder/$localsFileName
        "" | Add-Content -Path $moduleFolder/$localsFileName
    }

    $tfGroupMapping | ConvertTo-Json -Depth 100 | Set-Content -Path $mappingFileName
    @'
  }
}
'@ | Add-Content -Path $moduleFolder/$localsFileName

    Remove-Item -Path "exportedGroup.tf"

    & $tfExecutable fmt $moduleFolder/$localsFileName
}

function Import-MappedObjects {
    param(
        $mappingFileName = "mappings.groups.json",
        $resourceName = 'module.groups[0].azuread_group.all["{TFName}"]',
        $objectVar = "{TFName}",
        $tfExecutable = "tofu",
        $objectPrefix = ""
    )

    # Read the mapping file
    $mapping = Get-Content -Raw $mappingFileName | ConvertFrom-Json -Depth 100 -AsHashtable

    # Get list of existing resources
    $existingResources = & $tfExecutable state list

    # Iterate over the mapping and generate the import commands
    foreach ($uid in $mapping.Keys) {
        $TFName = $mapping[$uid]
        $resourceString = $resourceName -replace $objectVar, $TFName
        if ($existingResources -contains $resourceString) {
            "## Resource '$resourceString' already exists in the state."
            continue
        }
        & $tfExecutable import $resourceString ($objectPrefix + $uid)
    }

}

function Import-EntraIDGroups {
    param(
        $mappingFileName = "mappings.groups.json",
        $resourceName = 'module.groups[0].azuread_group.all["{TFName}"]',
        $tfExecutable = "tofu"
    )

    Import-MappedObjects -mappingFileName $mappingFileName -resourceName $resourceName -tfExecutable $tfExecutable -objectPrefix "/groups/"

}

function Export-IntuneFilters {
    param (
        $moduleFolder = "filters",
        $localsFileName = "def.exported.tf",
        $tfLocalsName = "all_filters_exported",
        $mappingFileName = "mappings.filters.json",
        $tfExecutable = "tofu",
        [switch]$overwrite = $false
    )

    $filters = Invoke-MGGraphRequestAll -Uri 'https://graph.microsoft.com/beta/deviceManagement/assignmentFilters?$select=id,displayName,platform,assignmentFilterManagementType,description,rule'

    if (-not $overwrite) {
        if (Test-Path $moduleFolder/$localsFileName) {
            "## File $moduleFolder/$localsFileName already exists."
            throw "File $moduleFolder/$localsFileName already exists."
        }
        if (Test-Path $mappingFileName) {
            "## File $mappingFileName already exists."
            throw "File $mappingFileName already exists."
        }
    }

    $tfFiltersMapping = @{
    }

    # Make sure directories exist
    if (-not (Test-Path $moduleFolder)) { New-Item -ItemType Directory -Path $moduleFolder }
    if (-not (Test-Path "$moduleFolder/json")) { New-Item -ItemType Directory -Path "$moduleFolder/json" }

    @"
# -------------------------------------------------------------------------------
# Intune Filters - File exported via script 'tools/export/wf-export-library.ps1'
# -------------------------------------------------------------------------------


locals {
  $($tfLocalsName) = {

"@ | Set-Content -Path $moduleFolder/$localsFileName

    foreach ($filter in $filters) {
        #$filterTFObject = $filter | Select-Object -Property displayName, platform, assignmentFilterManagementType, description, rule
        $filterTfName = build-name -name $filter.displayName
        #$tfFiltersExport[$filterTfName] = $filterTFObject
        # Check that the mapping does not already contain the id or FilterTFName
        if ($tfFiltersMapping.ContainsKey($filter.id) -or $tfFiltersMapping.ContainsValue($filterTfName)) {
            "## Filter ID or FilterTFName already exists in the mapping."
            "## Filter ID: $($filter.id)"
            "## FilterTFName: $filterTfName"
            throw "Filter ID or FilterTFName already exists in the mapping."
        }
        $tfFiltersMapping[$filter.id] = $filterTfName

        # Create a raw JSON export as backup
        $filter | ConvertTo-Json -Depth 100 | Set-Content -Path "$moduleFolder/json/$filterTfName.json"

        Generate-TFConfig -resourceType "microsoft365wp_device_and_app_management_assignment_filter" -importId $filter.id -resourceName $filterTfName -outPath "exportedFilter.tf" -terraformExecutable $tfExecutable

        $tfTemplate = (Get-Content -Path "exportedFilter.tf") -replace "resource `"microsoft365wp_device_and_app_management_assignment_filter`" `".*`" {", "$($filterTfName) = {"

        # Remove unneeded attributes
        $attributesToRemove = @()
        foreach ($attribute in $attributesToRemove) {
            "## replacing $attribute"
            $tfTemplate = $tfTemplate -replace "(?im)^\s*$attribute\s*=\s*.*$", ''
        }

        # Warn if tfTemplate is contains a unique identifier (that is not resolved)
        if ($tfTemplate -match "[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}") {
            "## Found a unique identifier in $groupTfName that is not resolved." >> log.txt
        }

        # Remove empty lines
        $tfTemplate = $tfTemplate | Where-Object { $_ -ne "" }

        $tfTemplate | Add-Content -Path $moduleFolder/$localsFileName
        "" | Add-Content -Path $moduleFolder/$localsFileName
    }

    $tfFiltersMapping | ConvertTo-Json -Depth 100 | Set-Content -Path $mappingFileName
    @'
}
}
'@ | Add-Content -Path $moduleFolder/$localsFileName

    Remove-Item -Path "exportedFilter.tf"

    & $tfExecutable fmt $moduleFolder/$localsFileName
}

function Import-IntuneFilters {
    param(
        $mappingFileName = "mappings.filters.json",
        $resourceName = 'module.filters[0].microsoft365wp_device_and_app_management_assignment_filter.all["{TFName}"]',
        $tfExecutable = "tofu"
    )

    Import-MappedObjects -mappingFileName $mappingFileName -resourceName $resourceName -tfExecutable $tfExecutable

}
function Export-IntuneNotificationMessageTemplates {
    param (
        $moduleFolder = "compliance-policies",
        $localsFileName = "def.notification_message.exported.tf",
        $tfLocalsName = "def_notification_message_templates_exported",
        $mappingFileName = "mappings.notification-message-templates.json",
        $tfExecutable = "tofu",
        [switch]$overwrite = $false
    )

    $notificationMessageTemplates = Invoke-MGGraphRequestAll -Uri 'https://graph.microsoft.com/beta/deviceManagement/notificationMessageTemplates?$expand=localizedNotificationMessages'

    if (-not $overwrite) {
        if (Test-Path $moduleFolder/$localsFileName) {
            "## File $moduleFolder/$localsFileName already exists."
            throw "File $moduleFolder/$localsFileName already exists."
        }
        if (Test-Path $mappingFileName) {
            "## File $mappingFileName already exists."
            throw "File $mappingFileName already exists."
        }
    }

    $tfMapping = @{
    }

    # Make sure directories exist
    if (-not (Test-Path $moduleFolder)) { New-Item -ItemType Directory -Path $moduleFolder }
    if (-not (Test-Path "$moduleFolder/json")) { New-Item -ItemType Directory -Path "$moduleFolder/json_notification_message_template" }

    @"
# ------------------------------------------------------------------------------------------------
# Intune Compliance Not. Templates - File exported via script 'tools/export/wf-export-library.ps1'
# ------------------------------------------------------------------------------------------------


locals {
  $($tfLocalsName) = {

"@ | Set-Content -Path $moduleFolder/$localsFileName

    foreach ($notificationMessageTemplate in $notificationMessageTemplates) {
        $notificationMessageTemplateTfName = build-name -name $notificationMessageTemplate.displayName
        # Check that the mapping does not already contain the id or PolicyTFName
        if ($tfMapping.ContainsKey($notificationMessageTemplate.id) -or $tfMapping.ContainsValue($notificationMessageTemplateTfName)) {
            "## Notification Message Template ID or NotificationMessageTemplateTFName already exists in the mapping."
            "## Notification Message Template ID: $($notificationMessageTemplate.id)"
            "## NotificationMessageTemplateTFName: $notificationMessageTemplateTfName"
            throw "Notification Message Template ID or NotificationMessageTemplateTFName already exists in the mapping."
        }
        $tfMapping[$notificationMessageTemplate.id] = $notificationMessageTemplateTfName

        # Create a raw JSON export as backup
        $notificationMessageTemplate | ConvertTo-Json -Depth 100 | Set-Content -Path "$moduleFolder/json_notification_message_template/$notificationMessageTemplateTfName.json"

        Generate-TFConfig -resourceType "microsoft365wp_notification_message_template" -importId $notificationMessageTemplate.id -resourceName $notificationMessageTemplateTfName -outPath "exportedNotificationMessageTemplate.tf" -terraformExecutable $tfExecutable

        $tfTemplate = (Get-Content -Path "exportedNotificationMessageTemplate.tf") -replace "resource `"microsoft365wp_notification_message_template`" `".*`" {", "$($notificationMessageTemplateTfName) = {"

        # Remove unneeded attributes
        $attributesToRemove = @()
        foreach ($attribute in $attributesToRemove) {
            "## replacing $attribute"
            $tfTemplate = $tfTemplate -replace "(?im)^\s*$attribute\s*=\s*.*$", ''
        }

        # Warn if tfTemplate is contains a unique identifier (that is not resolved)
        if ($tfTemplate -match "[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}") {
            "## Found a unique identifier in $groupTfName that is not resolved." >> log.txt
        }

        # Remove empty lines
        $tfTemplate = $tfTemplate | Where-Object { $_ -ne "" }

        $tfTemplate | Add-Content -Path $moduleFolder/$localsFileName
        "" | Add-Content -Path $moduleFolder/$localsFileName
    }

    $tfMapping | ConvertTo-Json -Depth 100 | Set-Content -Path $mappingFileName
    @'
}
}
'@ | Add-Content -Path $moduleFolder/$localsFileName

    Remove-Item -Path "exportedNotificationMessageTemplate.tf"

    & $tfExecutable fmt $moduleFolder/$localsFileName
}

function Import-IntuneNotificationMessageTemplates {
    param(
        $mappingFileName = "mappings.notification-message-templates.json",
        $resourceName = 'module.compliance_policies[0].microsoft365wp_notification_message_template.all["{TFName}"]',
        $tfExecutable = "tofu"
    )

    Import-MappedObjects -mappingFileName $mappingFileName -resourceName $resourceName -tfExecutable $tfExecutable
}

function Export-IntuneCompliancePolicies {
    param (
        $moduleFolder = "compliance-policies",
        $localsFileName = "def.exported.tf",
        $tfLocalsName = "all_compliance_policies_exported",
        $mappingFileName = "mappings.compliance-policies.json",
        $groupsFileName = "mappings.groups.json",
        $groupsResourceName = "var.groups_map.{groupTFName}.id",
        $notificationMessageTemplatesFileName = "mappings.notification-message-templates.json",
        $notificationMessageTemplatesResourceName = 'microsoft365wp_notification_message_template.all["{nmTFName}"].id',
        $filterFileName = "mappings.filters.json",
        $filterResourceName = 'var.filters_map.{filterTFName}.id',
        $tfExecutable = "tofu",
        [switch]$overwrite = $false
    )

    $groupsMap = Get-Content -Raw $groupsFileName | ConvertFrom-Json -Depth 100 -AsHashtable
    $notificationMessageTemplatesMap = Get-Content -Raw $notificationMessageTemplatesFileName | ConvertFrom-Json -Depth 100 -AsHashtable
    $filterMap = Get-Content -Raw $filterFileName | ConvertFrom-Json -Depth 100 -AsHashtable

    $compliancePolicies = Invoke-MGGraphRequestAll -Uri 'https://graph.microsoft.com/beta/deviceManagement/deviceCompliancePolicies'

    if (-not $overwrite) {
        if (Test-Path $moduleFolder/$localsFileName) {
            "## File $moduleFolder/$localsFileName already exists."
            throw "File $moduleFolder/$localsFileName already exists."
        }
        if (Test-Path $mappingFileName) {
            "## File $mappingFileName already exists."
            throw "File $mappingFileName already exists."
        }
    }

    $tfMapping = @{
    }

    # Make sure directories exist
    if (-not (Test-Path $moduleFolder)) { New-Item -ItemType Directory -Path $moduleFolder }
    if (-not (Test-Path "$moduleFolder/json")) { New-Item -ItemType Directory -Path "$moduleFolder/json" }

    @"
# --------------------------------------------------------------------------------------
# Intune Compliance Pol. - File exported via script 'tools/export/wf-export-library.ps1'
# --------------------------------------------------------------------------------------

locals {
  $($tfLocalsName) = {

"@ | Set-Content -Path $moduleFolder/$localsFileName

    foreach ($policy in $compliancePolicies) {
        $policyTfName = build-name -name $policy.displayName
        # Check that the mapping does not already contain the id or PolicyTFName
        if ($tfMapping.ContainsKey($policy.id) -or $tfMapping.ContainsValue($policyTfName)) {
            "## Policy ID or PolicyTFName already exists in the mapping."
            "## Policy ID: $($policy.id)"
            "## PolicyTFName: $policyTfName"
            throw "Policy ID or PolicyTFName already exists in the mapping."
        }
        $tfMapping[$policy.id] = $policyTfName

        # Create a raw JSON export as backup
        $policy | ConvertTo-Json -Depth 100 | Set-Content -Path "$moduleFolder/json/$policyTfName.json"

        Generate-TFConfig -resourceType "microsoft365wp_device_compliance_policy" -importId $policy.id -resourceName $policyTfName -outPath "exportedPolicy.tf" -terraformExecutable $tfExecutable

        $tfTemplate = (Get-Content -Path "exportedPolicy.tf") -replace "resource `"microsoft365wp_device_compliance_policy`" `".*`" {", "$($policyTfName) = {"

        # Replace filter object with reference
        foreach ($uid in $filterMap.Keys) {
            $filterString = $filterResourceName -replace "{filterTFName}", $filterMap[$uid]
            $tfTemplate = $tfTemplate -replace "(\s*)filter_id\s*=\s*`"$uid`"", "`$1filter_id = $filterString"
        }

        # Replace notification message template object with reference
        foreach ($uid in $notificationMessageTemplatesMap.Keys) {
            $notificationMessageTemplateString = $notificationMessageTemplatesResourceName -replace "{nmTFName}", $notificationMessageTemplatesMap[$uid]
            $tfTemplate = $tfTemplate -replace "(\s*)notification_template_id\s*=(\s*)`"$uid`"", "`$1notification_template_id   = try($notificationMessageTemplateString, `"00000000-0000-0000-0000-000000000000`")"
        }

        # Replace group object with reference
        foreach ($uid in $groupsMap.Keys) {
            $groupString = $groupsResourceName -replace "{groupTFName}", $groupsMap[$uid]
            $tfTemplate = $tfTemplate -replace "(\s*)group_id\s*=\s*`"$uid`"", "`$1group_id = $groupString"
        }

        # Remove unneeded attributes
        $attributesToRemove = @()
        foreach ($attribute in $attributesToRemove) {
            "## replacing $attribute"
            $tfTemplate = $tfTemplate -replace "(?im)^\s*$attribute\s*=\s*.*$", ''
        }

        # Warn if tfTemplate is contains a unique identifier (that is not resolved)
        if ($tfTemplate -match "[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}") {
            "## Found a unique identifier in $groupTfName that is not resolved." >> log.txt
        }

        # Remove empty lines
        $tfTemplate = $tfTemplate | Where-Object { $_ -ne "" }

        $tfTemplate | Add-Content -Path $moduleFolder/$localsFileName
        "" | Add-Content -Path $moduleFolder/$localsFileName
    }

    $tfMapping | ConvertTo-Json -Depth 100 | Set-Content -Path $mappingFileName
    @'
}
}
'@ | Add-Content -Path $moduleFolder/$localsFileName

    Remove-Item -Path "exportedPolicy.tf"

    & $tfExecutable fmt $moduleFolder/$localsFileName
}

function Import-IntuneCompliancePolicies {
    param(
        $mappingFileName = "mappings.compliance-policies.json",
        $resourceName = 'module.compliance_policies[0].microsoft365wp_device_compliance_policy.all["{TFName}"]',
        $tfExecutable = "tofu"
    )

    Import-MappedObjects -mappingFileName $mappingFileName -resourceName $resourceName -tfExecutable $tfExecutable
}
