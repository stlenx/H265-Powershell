function Test-Directory(){
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Path
    )

    if($Path -Match "\[|\]"){
        $Path = $Path.Replace('[', '``[')
        $Path = $Path.Replace(']', '``]')
    }
    
    if(!(test-path $Path)){
        Write-Host -ForegroundColor Red -BackgroundColor Black "Path $Path is not valid. Please input a valid path and try again."
        break
    }

    return $Path
}