#
# Module manifest for module 'Convert-VideoFile'
#
# Generated by: ixi
#
# Contributors: ixi & Sariku
#
# Generated on: 07/03/2021
#

@{

# Script module or binary module file associated with this manifest.
# RootModule = ''

# Version number of this module.
ModuleVersion = '1.0'

# Supported PSEditions
# CompatiblePSEditions = @()

# ID used to uniquely identify this module
GUID = 'c040c0ec-73b7-4e28-ab6a-e3123b34812f'

# Author of this module
Author = 'ixi & Sariku'

# Company or vendor of this module
CompanyName = 'N/A'

# Copyright statement for this module
Copyright = '(c) 2021 ixi & Sariku. All rights reserved.'

# Description of the functionality provided by this module
Description = 'This module enables transcoding of whole-directories of video files using ffmpeg'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '5.1.19041.610'

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
NestedModules = @(
    '.\Functions\Convert-2HEVC.ps1'
    '.\Functions\ConvertTo-MP3.ps1'
    '.\Functions\Get-StreamCount.ps1'
)

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = @('*')

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
VariablesToExport = '*'

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = @()

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
# FileList = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        # Tags = @()

        # A URL to the license for this module.
        LicenseUri = 'https://github.com/stlenx/H265-Powershell'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/stlenx/H265-Powershell'

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        # ReleaseNotes = ''

    } # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
HelpInfoURI = 'https://github.com/stlenx/H265-Powershell/wiki'

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

