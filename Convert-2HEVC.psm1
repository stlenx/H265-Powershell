function Convert-2HEVC {
    param (
        [alias('d')]
        $dir
    )

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