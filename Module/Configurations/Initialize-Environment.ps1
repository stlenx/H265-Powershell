function Import-JSON {
    param (
        $Path
    )
    
    [String]$Contents = (Get-Content $Path)
    
    return (ConvertFrom-Json $Contents)
}


if([String]::IsNullOrWhiteSpace($PSScriptRoot)){
    $Global:ScriptRoot = (Split-Path $MyInvocation.MyCommand.Path -Parent)
} else {
    $Global:ScriptRoot = $PSScriptRoot
}

if($Global:ScriptRoot -ne $ScriptRoot){
    $ScriptRoot = $Global:ScriptRoot
}

$Global:Configuration = (Import-JSON ".\Configurations\main.conf.json")