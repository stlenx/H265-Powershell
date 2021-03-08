function Convert-2HEVC {
	param (
		[alias('d')]
		$Dir,
		[alias('p')]
		$Preset,
		[switch]$GPU
	)

	Begin {

		# Config lists

		$ValidPresets = (
			"fast",
			"medium",
			"slow"
		)

		$formats = (
			'mp4',
			'mkv'
		)
		
		$hwaccel = (
			'',
			'libx265'
		)
		
		if($GPU) {
			$hwaccel[0] = '-hwaccel cuda -hwaccel_output_format cuda'
			$hwaccel[1] = 'hevc_nvenc'
		}

		# Clearing the terminal becuase this makes shit tidy.
		Clear-Host

		while(!($ValidPresets -contains $Preset)) {
			if($Preset) {
				write-Host -BackgroundColor Black -ForegroundColor Red "Preset of: '$Preset' is not valid. Please select a valid Preset."
			}
			$Preset = (read-host "Please input a valid option (fast, medium or slow)")
		}
		
		$UnformatDir = $Dir

		# Okay I'm less angry about this now. But still fuck you for adding [] to dir names.
		if($Dir -Match "\[|\]"){
			$Dir = $Dir.Replace('[', '``[')
			$Dir = $Dir.Replace(']', '``]')
		}
		
		if(!(test-path $Dir)){
			Write-Host -ForegroundColor Red -BackgroundColor Black "Path $Dir is not valid. Please input a valid path and try again."
			break #69
		}
		
		# Chage to the Dir because running get-childitem is fucked.
		cd $Dir
	}

	Process{
		if(!(test-path $UnformatDir\Converted)) {
			new-item $UnformatDir\Converted -itemtype Directory
		}

		foreach ($File in (Get-ChildItem)) {
			if($formats -contains ($File.name.split('.')[-1])) {
				$Name = $File.name
				$input = "$UnformatDir\$Name"
				$output = "$UnformatDir\Converted\$Name"
				ffmpeg $hwaccel[0] -i $input -map 0 -c copy -c:v $hwaccel[1] -Preset $Preset $output
			}
		}
	}
}
