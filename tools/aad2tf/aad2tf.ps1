#!/usr/bin/env pwsh

#requires -version 7.4

param (
    [string]$resourceType,
    [string]$id,
    [string]$terraformExecutable = "terraform",
    [switch]$initUpgrade,
    [switch]$debug
)

if ($debug) { $DebugPreference = "Continue" }

$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true
Set-StrictMode -Version 3


$idStub = ($id -replace '[^0-9a-f]', '').Substring(0, 8)
$resourceName = "id_${idStub}"

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
            source = "registry.terraform.io/terraprovider/microsoft365wp"
        }
    }
}

import {
    to = ${resourceType}.${resourceName}
    id = "${id}"
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
    "workplace_device_management_configuration_policy" {
        $result = $result -replace '(?im)^\s*template_reference\s*=\s*\{[\n\s]*\}\n', '' # empty template_reference
    }
}

# format to remove extra spaces
$result = $result | terraform fmt -

$outPath = "${resourceType}_${idStub}.tf"
$result | Out-File $outPath -Encoding utf8NoBOM

Write-Host
Write-Host "###"
Write-Host "### Completed successfully, result added to $outPath"
Write-Host "###"
