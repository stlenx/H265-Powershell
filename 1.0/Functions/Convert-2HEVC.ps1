function Convert-2HEVC {
	param (
		[alias('d')]
		$Dir,
		[alias('p')]
		$Preset,
		[switch]$GPU,
		[switch]$Audio
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
		
		if($GPU) {
			$hwaccel = (
				'hevc_nvenc',
				'-hwaccel',
				'cuda',
				'-hwaccel_output_format',
				'cuda'
			)

			#$CpuOrGpu = 'hevc_nvenc'
			#$HwAccel = @{ hwaccel = 'cuda'; hwaccel_output_format = 'cuda' }
		} else {
			$hwaccel = (
				'libx265',
				'',
				'',
				'',
				''
			)

			#$CpuOrGpu = 'libx265'
		}

		if($Audio) {
			$ConvertAudio = (
				'-c:a',
				'aac',
				'-b:a',
				'128k'
			)
		} else {
			$ConvertAudio = (
				'',
				'',
				'',
				''
			)
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
				ffmpeg $hwaccel[1] $hwaccel[2] $hwaccel[3] $hwaccel[4] -i $input -map 0 -c copy $ConvertAudio[0] $ConvertAudio[1] $ConvertAudio[2] $ConvertAudio[3] -c:v $hwaccel[0] -preset $Preset $output
			}
		}
	}
}