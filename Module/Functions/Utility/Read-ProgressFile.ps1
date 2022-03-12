function Read-ProgressFile(){
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Path
    )

    $Progress = @{}
    if($Null -eq (Get-Content $Path)){
        continue
    }
    
    foreach($line in Get-Content $Path -Tail 12){
        $Split = $Line.Split('=')
        $Progress[$Split[0]] = $Split[1]
    }

    return $Progress
}