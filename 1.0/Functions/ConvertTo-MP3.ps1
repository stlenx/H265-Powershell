function ConvertTo-MP3(){
    param (
		[Parameter(Mandatory=$true)]		
        [alias('d')]
        $Dir,
        [switch]$Recurse,
        [ValidateSet("32k","40k","48k","56k","64k","80k","96k","112k","128k","160k","192k","224k","256k","320k")]
        [alias('br')]
        $BitRate = "320k",
        [ValidateSet(32000, 44100, 48000)]
        [alias('sr')]
        $SampleRate = 48000
    )

    begin{
        function ConvertTo-Timespan($Time){
            $textReformat = $Time -replace ",","."
            return ([TimeSpan]::Parse($textReformat))
        }

        $FilesToDelete = [System.Collections.ArrayList]@()

        $FuckyWuckyTempFileToPassToStartProcess = [IO.Path]::GetTempPath() + "fuckthis.tmp"
        [Void]$FilesToDelete.Add($FuckyWuckyTempFileToPassToStartProcess)

        $AcceptableFormats = (
        ".3gp",  ".aa",   ".aac",  ".aax",
        ".act",  ".aiff", ".alac", ".amr",
        ".ape",  ".au",   ".awb",  ".dss",
        ".dvf",  ".flac", ".gsm",  ".iklax",
        ".ivs",  ".m4a",  ".m4b",  ".m4p",
        ".mmf",  ".cda",  ".mpc",  ".msv",
        ".nmf",  ".ogg",  ".oga",  ".mogg",
        ".opus", ".ra",   ".rm",   ".raw",
        ".rf64", ".sln",  ".tta",  ".voc",
        ".vox",  ".wav",  ".wma",  ".wv",
        ".webm", ".8svx"
        )

        $ChildItemSplat = @{}

        if($Recurse){
            $ChildItemSplat["-Recurse"] = $True
        }

        $ChildItemSplat["Path"] = $Dir

        $Files = (Get-ChildItem @ChildItemSplat | Where-Object{$_.Extension -in $AcceptableFormats})
    }

    process{
        $TotalFiles = $Files.Count
		$FilesComplete = 0

        foreach($File in $Files){
            $Percent = ($FilesComplete * 100) / $TotalFiles
            Write-Progress -Activity "Converting $($File.Name)" -Status "$Percent% Complete ($FilesComplete/$TotalFiles)" -PercentComplete $Percent -Id 1
            
            $FileName = $File.FullName

            $FileBase = ([System.IO.Path]::GetFileNameWithoutExtension($FileName))

            $ProgressFile = (New-TemporaryFile).FullName
            [Void]$FilesToDelete.Add($ProgressFile)

            $NewName = $FileBase + ".mp3"
            $Output = [IO.Path]::Combine((Split-Path $FileName), $NewName)

            if(Test-Path $Output){
                continue
            }

            $Options = "$FileName|$BitRate|$SampleRate|$Output|$ProgressFile"

            $Options >> $FuckyWuckyTempFileToPassToStartProcess

            $ffmpeg = (start-process -NoNewWindow powershell {

                $FuckyWuckyTempFileToPassToStartProcess = [IO.Path]::GetTempPath() + """fuckthis.tmp"""

                $Options = (Get-Content $FuckyWuckyTempFileToPassToStartProcess -Tail 1).Split('|')

                $FileName = $Options[0]
                $BitRate = $Options[1]
                $SampleRate = $Options[2]
                $Output = $Options[3]
                $ProgressFile = $Options[4]

                # $Parameters = (
                #     "-hide_banner",
                #     "-loglevel", "error",
                #     "-i", "`"$FileName`"",
                #     "-ab", "$BitRate",
                #     "-ar", "$SampleRate",
                #     "-map_metadata", 0,
                #     "-id3v2_version", 3,
                #     "`"$Output`"",
                #     "-progress", "`"$ProgressFile`""
                # )

                #ffmpeg $Parameters
                ffmpeg -hide_banner -loglevel error -i """$FileName""" -ab $BitRate -ar $SampleRate -map_metadata 0 -id3v2_version 3 """$Output""" -progress """$ProgressFile"""
            
            } -PassThru)
            
            $PercentProcessed = 0
        
            Try{
                While(get-process -ID $ffmpeg.id -ErrorAction Stop| Select-Object -property Responding){
                    $Duration = [timespan]::FromSeconds((ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $FileName))
                
                    $Progress = @{}
                    if($Null -eq (Get-Content $ProgressFile)){
                        continue
                    }
                    
                    foreach($line in Get-Content $ProgressFile -Tail 12){
                        $Split = $Line.Split('=')
                        $Progress[$Split[0]] = $Split[1]
                    }
                
                    $ProgressTime = (ConvertTo-Timespan $Progress.out_time)

                    if($ProgressTime -gt $Duration){
                        continue
                    }

                    $PercentProcessed = [math]::Round((($ProgressTime.Ticks * 100) / $Duration.Ticks),2)
                
                    Write-Progress -Activity "Processing" -Status "$PercentProcessed% Complete" -PercentComplete $PercentProcessed -ParentId 1
                }
            } Catch {}

            $FilesComplete++
        }


    }

    end{
        Foreach($File in $FilesToDelete){
            if(Test-Path $File){
                Remove-Item $File
            }
        }
    }
}