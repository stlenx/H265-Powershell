function Convert-2HEVC {
	param (
		[Parameter(Mandatory=$true)]		
		[alias('d')]
		$Dir,
		[alias('p')]
		$Preset,
		[switch]$UseGPU,
		[switch]$Audio
	)

	Begin {

		# Config lists
		$SupportedFormats = (
			".webm",
			".mkv",
			".flv",
			".ogg",
			".avi",
			".TS",
			".mov",
			".wmv",
			".mp4",
			".m4p",
			".m4v",
			".mpg",
			".mpeg",
			".3gp"
		)

		$ValidPresets = (
			"fast",
			"medium",
			"slow"
		)

		$formats = (
			'.mp4',
			'.mkv'
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
			$Name = $File.name

			if(!($SupportedFormats -Contains $File.Extension)){
				continue
			}

			$InputFile = "$UnformatDir\$Name"

			if(!($formats -Contains $File.Extension)){
				$Name = [string]$Name -Replace $File.Extension, ".mp4"
			}

			$OutputFile = "$UnformatDir\Converted\$Name"

			Write-Host $OutputFile

			# Build Options
			# If GPU prepend with hwaccel info
			# If Audio, prepend output with Audio info
			if($UseGPU) {
				$CPUorGPU = (
					"-hwaccel", "cuda",
					"-hwaccel_output_format", "cuda",
					"-i", "$InputFile",
					"-c:v", "hevc_nvenc"
				)
			} else {
				$CPUorGPU = (
					"-i", "$InputFile",
					"-c:v", "libx265"
				)
			}

			if($Audio) {
				$Options = $CPUorGPU + (
					"-c:a", "aac",
					"-b:a", "320k",
					"-preset", $Preset.ToLower(),
					$OutputFile
				)
			} else {
				$Options = $CPUorGPU + (
					"-preset", $Preset.ToLower(),
					$OutputFile
				)
			}
			ffmpeg $Options
			
		}
	}
}
