function Import-JSON {
    param (
        $Path
    )
    
    [String]$Contents = (Get-Content $Path)
    
    return (ConvertFrom-Json $Contents)
}