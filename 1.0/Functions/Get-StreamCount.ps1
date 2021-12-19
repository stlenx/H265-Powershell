function Get-StreamCount {
    param (
        $InputFile,

        [ValidateSet("v", "a", "s")]
        $StreamType
    )
    
    return (ffprobe -v error -select_streams $StreamType -show_entries stream=index -of csv=p=0 $InputFile).Count
}