@echo off
setlocal enabledelayedexpansion

:: Set default values
set "folder="
set "width=1280"
set "height=720"
set "codec=h264_nvenc"
set "audioCodec=aac"
set "extension=mp4"
set "extraOptions=-preset medium"

:: Parse command line arguments
:parseArgs
if "%~1"=="" goto :argsParsed
set "folder=%~1"
shift
goto :parseArgs

:argsParsed
if "%folder%"=="" (
    echo Usage: %0 [folder]
    exit /b 1
)
echo Processing %folder%
:: Process each .mp4 and .mov file in the specified folder
for %%f in ("%folder%\*.mp4" "%folder%\*.mov") do (
    echo Processing: "%%~nf"
    ffmpeg -hwaccel_device 0 -hwaccel cuda -i "%%f" -vf "scale=%width%:%height%" -pix_fmt yuv420p -c:v !codec! !extraOptions! -c:a !audioCodec! "%folder%\%%~nf_out.!extension!"
)

echo Conversion completed.
endlocal
