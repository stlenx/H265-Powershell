# H265-Powershell

[![forthebadge](https://forthebadge.com/images/badges/works-on-my-machine.svg)](https://forthebadge.com)

Powershell module that uses ffmpeg to automatically convert video files to H265/HEVC

## Installation

1. Download the module and place it in C:\Program Files\WindowsPowerShell\Modules

2. Open powershell and type `Import-module *module name*`.

3. Download ffpeg from `https://ffmpeg.org/` and add it to your Path (https://www.architectryan.com/2018/03/17/add-to-the-path-on-windows-10/ <- Guide).

## Usage

Open powershell and type `Convert-2HEVC` followed by the path to the folder containing the videos you wish to convert in double quotes. 
(ex `Convert-2HEVC "P:\unsorted\Initial_D"`). After this you can add the transcoding speed which can be either fast, medium or slow. If you don't add this option you will be promted to input it.

 -Fast gives serveral times faster transcoders compared to slow (depends on the file you are transcoding) at the cost of some slight compresion artifacts and slight bigger file size (both very minimal).

 -Medium gives just a few frames per second more than slow and has the same problems as fast (not recommended).

 -Slow gives the best video quality at the cost of transconding speed.

The module will make a folder called "Converted" in the specified path and place the transcoded videos in there. The file names will not be changed. Transcoding will take use of the gpu for faster operation using nvidia nvenc, therefore a Nvidia gpu will be necesary :( (More info on which GPUs are supported here -> https://developer.nvidia.com/video-encode-and-decode-gpu-support-matrix-new)

## Example

Converted a .mkv file that was 1.09GB to just 439MB:

![exampleConversion](https://github.com/stlenx/Images/blob/main/ScriptDoesThePog_LI.jpg)
