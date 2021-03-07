function Convert-2HEVC {
    param (
        [alias('d')]
        $dir
    )

    Begin {
		$UnformatDir = $dir
        # Check to make sure $dir is sane.
        # Kill those fucking dirty ass motherfuckin stupid ass piece of shit square-bracket-in-path bastards

        if($dir -Match "\["){
            # Found a fuckin square bracket. Fuck these guys. Get yeeted to fuck.
            $dir = $dir.Replace('[', '``[')
        }

        # Have I mentioned how much I hate these pieces of shit?
        # Because I really. fucking. hate. these.

        if($dir -Match "\]"){
            # Found a fuckin square bracket. Fuck these guys. Get yeeted to fuck.
            $dir = $dir.Replace(']', '``]')
        }

        # Fuck you weeb folder maker cunts. Putting fuckin brackets into your folder names so I have to spend
        # Ages figuring why this shit is broken and troubleshooting just to make this fuckin code work.
        # Reeeeeeeeeeeeeeeeeeeeeeeee
        
        if(!(test-path $dir)){
            Write-Host -ForegroundColor Red -BackgroundColor Black "Path $dir is not valid. Please input a valid path and try again."
            break #69
        }
		
        # Chage to the dir because running get-childitem is fucked.
		cd $dir
    }

    Process{
        # haha. look at these stupid ass motherfuckin formats.
        $formats = (
			'mp4',
			'mkv'
        )

        # Does the stupid fuckin path exist?
        # Does it Jerry?
        # Does it?
        if(!(test-path $UnformatDir\Converted)) {
            # Does it fuck.
            new-item $UnformatDir\Converted -itemtype directory
        }

        foreach ($File in (Get-ChildItem)) {
            if($formats -contains ($File.name.split('.')[-1])) {
				write-host $dir
                $Name = $File.name
                ffmpeg -hwaccel cuda -hwaccel_output_format cuda -i "$UnformatDir\$Name" -c:v hevc_nvenc -preset slow "$UnformatDir\Converted\$Name"
            }
        }
    }
}
