function Convert-2HEVC {
	param (
		[alias('d')]
		$Dir,
		[alias('p')]
		$Preset
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
		
		# Set the working directory to be the input. This is because Get-ChildItem is pretty fucked because of the aforementioned shitty square brackets.
		Set-Location $Dir
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
				ffmpeg -hwaccel cuda -hwaccel_output_format cuda -i $input -map 0 -c copy -c:v hevc_nvenc -Preset $Preset $output
			}
		}
	}
}
