function Convert-2HEVC {
	param (
		[Parameter(Mandatory=$true)]		
		[alias('d')]
		$Dir,
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

		$formats = (
			'.mp4',
			'.mkv'
		)
		
		# Clearing the terminal becuase this makes shit tidy.
		Clear-Host
		
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

		$Total = (Get-ChildItem).Count
		$i = 0

		foreach ($File in (Get-ChildItem)) {
			$Percent = ($i * 100) / $Total
			# Write-Progress -Activity "Converting" -Status "$Percent% Complete:" -PercentComplete $Percent

			$Name = $File.name

			if(!($SupportedFormats -Contains $File.Extension)){
				continue
			}

			$InputFile = "$UnformatDir\$Name"

			if(!($formats -Contains $File.Extension)){
				$Name = [string]$Name -Replace $File.Extension, ".mp4"
			}

			$OutputFile = "$UnformatDir\Converted\$Name"

			# Build Options
			# If GPU prepend with hwaccel info
			# If Audio, prepend output with Audio info
			$Options = (
				"-hide_banner",
				"-loglevel", "info"
				# "-nostats", 
				# "-progress", "-"
			)

			if($UseGPU) {
				$Options += (
					"-hwaccel", "cuda",
					"-hwaccel_output_format", "cuda",
					"-i", "$InputFile",
					"-c:v", "hevc_nvenc"
				)
			} else {
				$Options += (
					"-i", "$InputFile",
					"-c:v", "libx265"
				)
			}

			if($Audio) {
				$Options += (
					"-c:a", "aac",
					"-b:a", "320k"
				)
			}

			$Options += (
					"-map", "0:v",
					"-map", "0:a",
					"-map", "0:s",
					"$OutputFile"
			);

			ffmpeg $Options

			$i++;
		}
	}
}