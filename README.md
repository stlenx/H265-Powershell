# H265-Powershell

Powershell module that uses ffmpeg to automatically convert video files to H265/HEVC

## Installation

1. Download the module and place it in C:\Program Files\WindowsPowerShell\Modules

2. Open powershell and type `Import-module *module name*`.

## Usage

Open powershell and type `Convert-2HEVC` followed by the path to the folder containing the videos you wish to convert in double quotes. 
(ex `Convert-2HEVC "P:\unsorted\Initial_D"`)

The module will make a folder called "Converted" in the specified path and place the transcoded videos in there. The file names will not be changed. Transcoding will take use of the gpu for faster operation using nvidia nvenc, therefore a Nvidia gpu will be necesary :(
