function ConvertTo-HEVC {
	param (
		[Parameter(Mandatory=$true)]		
		[alias('d')]
		$Dir,
		[switch]$UseGPU,
		[switch]$Audio
	)

	Begin {

		$FilesToDelete = [System.Collections.ArrayList]@()

        $FuckyWuckyTempFileToPassToStartProcess = [IO.Path]::GetTempPath() + "FFmpegConvert.tmp"
        [Void]$FilesToDelete.Add($FuckyWuckyTempFileToPassToStartProcess)

		$SupportedFormats = $Global:Configuration.SupportedVideoFormats
		$formats = $Global:Configuration.VideoOutputFiletypes

		$ChildItemSplat = @{}

        if($Recurse){
            $ChildItemSplat["-Recurse"] = $True
        }

		$ChildItemSplat["Path"] = $Dir

		$Files = (Get-ChildItem -LiteralPath $Dir | Where-Object{$_.Extension -in $SupportedFormats})
	}

	Process {

		if(!(Test-Path -LiteralPath "$Dir\Converted")) {
			New-Item "$Dir\Converted" -itemtype Directory
		}

        $TotalFiles = $Files.Count
		$FilesComplete = 0

		foreach($File in $Files){
			$Percent = [Math]::Round((($FilesComplete * 100) / $TotalFiles), 2)

			$ProgressSplat = @{
				Activity 		= "Converting $($File.Name)"
				Status 			= "$Percent% Complete ($FilesComplete/$TotalFiles)"
				PercentComplete = $Percent
				id 				= 1
			}
            Write-Progress @ProgressSplat

			$Name = $File.name

			if(!($SupportedFormats -Contains $File.Extension)){
				Write-Host "AAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
				continue
			}

			$InputFile = "$Dir\$Name"

			if(!($formats -Contains $File.Extension)){
				Write-Host $File.Extension
				$Name = [string]$Name -Replace $File.Extension, ".mp4"
			}

			$OutputFile = "$Dir\Converted\$Name"

			$ProgressFile = (New-TemporaryFile).FullName
            [Void]$FilesToDelete.Add($ProgressFile)

			# Build Options
			# If GPU prepend with hwaccel info
			# If Audio, prepend output with Audio info
			$Options = (
				"-hide_banner",
				"-loglevel", "error",
				"-nostats", 
				"-progress", "-"
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
					"-c:v", "libx265",
					"-x265-params", "log-level=error"
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
					"-map", "0:a?",
					"-map", "0:s?",
					"$OutputFile",
					"-progress", "$ProgressFile"
			)

			$Options -join "|" >> $FuckyWuckyTempFileToPassToStartProcess


			$ffmpeg = (Start-Process -NoNewWindow powershell {
				$FuckyWuckyTempFileToPassToStartProcess = [IO.Path]::GetTempPath() + """FFmpegConvert.tmp"""

				$Options = (Get-Content $FuckyWuckyTempFileToPassToStartProcess -Tail 1).Split('|')
				
				ffmpeg.exe $Options
			} -PassThru)

			$PercentProcessed = 0
        
            Try{

				$Duration = [timespan]::FromSeconds((ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $InputFile))
				
                While(get-process -ID $ffmpeg.id -ErrorAction Stop| Select-Object -property Responding){
                
                    $Progress = (Read-ProgressFile -Path $ProgressFile)
                
					$ProgressTime = (ConvertTo-Timespan $Progress.out_time)
					$FPS = $Progress.fps
					$Speed = $Progress.speed

                    if($ProgressTime -gt $Duration){
                        continue
                    }

					$PercentProcessed = [math]::Round((($ProgressTime.Ticks * 100) / $Duration.Ticks),2)
					
					$FFMPegProgressSplat = @{
						Activity 		= "Processing at $FPS FPS ($Speed)"
						Status 			= "$PercentProcessed% Complete"
						PercentComplete = $PercentProcessed
						Parentid 		= 1
					}
                
                    Write-Progress @FFMPegProgressSplat
                }
            } Catch {}

			$FilesComplete++;
		}
	}

	end {
        Foreach($File in $FilesToDelete){
            if(Test-Path $File){
                Remove-Item $File
            }
        }
	}
}