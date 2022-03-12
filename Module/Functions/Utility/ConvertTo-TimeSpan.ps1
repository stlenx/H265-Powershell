function ConvertTo-Timespan($Time){
    $textReformat = $Time -replace ",","."
    return ([TimeSpan]::Parse($textReformat))
}