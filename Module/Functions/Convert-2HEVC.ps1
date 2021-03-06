function Convert-2HEVC {
    param (
        [alias('d')]
        $dir
    )

    Begin {
        # Check to make sure $dir is sane.

        # Kill them fucking dirty ass motherfuckin stupid ass piece of shit square-bracket-in-path fuckery

        if($dir -Match "\["){
            # Found a fuckin square bracket. Fuck these guys. Get yeeted to fuck.
            $dir = $dir.Replace('[', '``[')
        }

        if($dir -Match "\]"){
            # Found a fuckin square bracket. Fuck these guys. Get yeeted to fuck.
            $dir = $dir.Replace(']', '``]')
        }

        
        if(!(test-path [string]$dir)){
            Write-Host -ForegroundColor Red -BackgroundColor Black "Path $dir is not valid. Please input a valid path and try again."
            exit 69
        }
    }

    Process{
        $formats = (
        'mp4',
        'mkv'
        )

        if(!(test-path "$dir\Converted")) {
            new-item "$dir\Converted" -itemtype directory
        }

        foreach ($path in (Get-ChildItem $dir)) {
            if($formats -contains ($path.name.split('.')[-1])) {
                $Name = $path.name
                ffmpeg -hwaccel cuda -hwaccel_output_format cuda -i $path.fullname -c:v hevc_nvenc -preset slow "$dir\Converted\$Name"
            }
        }
    }
}