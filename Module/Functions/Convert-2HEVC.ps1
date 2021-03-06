function Convert-2HEVC {
    param (
        [alias('d')]
        $dir
    )

    Begin {
		$UnformatDir = $dir
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

        
        if(!(test-path $dir)){
            Write-Host -ForegroundColor Red -BackgroundColor Black "Path $dir is not valid. Please input a valid path and try again."
            break #69
        }
		
		cd $dir
    }

    Process{
        $formats = (
			'mp4',
			'mkv'
        )

        if(!(test-path $UnformatDir\Converted)) {
            new-item $dir\Converted -itemtype directory
        }

        foreach ($path in (Get-ChildItem)) {
            if($formats -contains ($path.name.split('.')[-1])) {
				write-host $dir
                $Name = $path.name
                ffmpeg -hwaccel cuda -hwaccel_output_format cuda -i $UnformatDir\$Name -c:v hevc_nvenc -preset slow "$UnformatDir\Converted\$Name"
            }
        }
    }
}
