# Build ImperoDesk (Windows x64, Flutter UI) as a single ImperoDesk.exe.
# Usage:  powershell -ExecutionPolicy Bypass -File .\build-imperodesk.ps1
# Output: dist\ImperoDesk.exe  (unpacked app: flutter\build\windows\x64\runner\Release\)
$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot

# Use the VS 2022 C++ toolchain (same one vcpkg built the libraries with)
$vs = 'C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools'
cmd /c "`"$vs\VC\Auxiliary\Build\vcvars64.bat`" >nul && set" | ForEach-Object {
    if ($_ -match '^([^=]+)=(.*)$') { Set-Item -Path "env:$($Matches[1])" -Value $Matches[2] }
}

$env:Path = "C:\dev\flutter\bin;$env:USERPROFILE\.cargo\bin;C:\Program Files\LLVM\bin;C:\Program Files\Git\cmd;$env:Path"
$env:VCPKG_ROOT = 'C:\dev\vcpkg'
$env:LIBCLANG_PATH = 'C:\Program Files\LLVM\bin'

# Start from a clean Flutter Windows build: stale files must never end up in the
# package, and CMake caches the exe name / install prefix between builds
$release = 'flutter\build\windows\x64\runner\Release'
if (Test-Path 'flutter\build\windows') { Remove-Item 'flutter\build\windows' -Recurse -Force }

python build.py --portable --flutter --skip-portable-pack --hwcodec --vram
if ($LASTEXITCODE -ne 0) { throw "build.py failed with exit code $LASTEXITCODE" }

# Pack the whole app folder into one self-extracting exe
python -m pip install --quiet -r libs\portable\requirements.txt
if ($LASTEXITCODE -ne 0) { throw "pip install failed" }
Push-Location libs\portable
python generate.py -f "..\..\$release" -o . -e ImperoDesk.exe
$packExit = $LASTEXITCODE
Pop-Location
if ($packExit -ne 0) { throw "portable packer failed with exit code $packExit" }

New-Item -ItemType Directory -Force dist | Out-Null
Copy-Item target\release\rustdesk-portable-packer.exe dist\ImperoDesk.exe -Force
Write-Host "Build OK: $(Resolve-Path dist\ImperoDesk.exe)"
