@echo off

REM HDRIs from https://polyhaven.com/hdris, converted with https://matheowis.github.io/HDRI-to-CubeMap/
REM texassemble and texconv from https://github.com/microsoft/DirectXTex

REM Ensure texconv.exe and texassemble.exe are present in the same directory as the script
if not exist "%~dp0texconv.exe" (
    echo texconv.exe must be in the same directory as this script.
    exit /b 1
)

if not exist "%~dp0texassemble.exe" (
    echo texassemble.exe must be in the same directory as this script.
    exit /b 1
)

REM Iterate through each folder in the current directory
for /D %%x in (*) do (
    echo Processing folder: %%x

    REM Assemble cubemap from the 6 hdr images
    "%~dp0texassemble.exe" cube "%%x\px.hdr" "%%x\nx.hdr" "%%x\py.hdr" "%%x\ny.hdr" "%%x\pz.hdr" "%%x\nz.hdr" -o "%%x.dds" -y
    if errorlevel 1 (
        echo texassemble failed for %%x
    )
	
	REM Convert the cubemap.dds to BC6H format
    "%~dp0texconv.exe" "%%x.dds" -f BC6H_UF16 -m 1 -y
    if errorlevel 1 (
        echo texconv failed for %%x
    )
)

echo Processing complete.
