function Get-MediaDuration(){
    [CmdletBinding()]
    param (
        $Path
    )

    $FFProbe = (ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $Path)

    return = [timespan]::FromSeconds($FFProbe)
}