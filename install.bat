@echo off
rem Installs the built mod into Geometry Dash and (optionally) starts the game.
rem Geode loads it on launch; nothing else needs to be hooked by hand.
rem
rem Usage:
rem   install.bat                 uses the first .geode found next to this file,
rem                               in mod-final\ or in build\
rem   install.bat path\to\mod.geode
rem Set GD_PATH to your Geometry Dash folder if it isn't in the default
rem Steam location.
setlocal enabledelayedexpansion
cd /d "%~dp0"

set "MOD=%~1"
if not defined MOD for %%f in (*.geode mod-final\*.geode build\*.geode) do if not defined MOD set "MOD=%%~ff"
if not defined MOD (
    echo No .geode file found. Download it from GitHub ^(Actions tab, latest run,
    echo "predictive-input-mod" artifact^), unzip it next to this file and run again.
    pause
    exit /b 1
)
if not exist "%MOD%" (
    echo "%MOD%" does not exist.
    pause
    exit /b 1
)

if not defined GD_PATH set "GD_PATH=%ProgramFiles(x86)%\Steam\steamapps\common\Geometry Dash"
if not exist "%GD_PATH%\GeometryDash.exe" (
    echo Couldn't find GeometryDash.exe in "%GD_PATH%".
    set /p "GD_PATH=Paste your Geometry Dash folder: "
    set "GD_PATH=!GD_PATH:"=!"
)
if not exist "%GD_PATH%\GeometryDash.exe" (
    echo GeometryDash.exe not found there either.
    pause
    exit /b 1
)
if not exist "%GD_PATH%\geode" (
    echo Geode isn't installed in "%GD_PATH%". Install Geode first: https://geode-sdk.org
    pause
    exit /b 1
)

if not exist "%GD_PATH%\geode\mods" mkdir "%GD_PATH%\geode\mods"
copy /y "%MOD%" "%GD_PATH%\geode\mods\zakme.predictive_input.geode" >nul || (
    echo Copy failed. Is Geometry Dash open? Close it and try again.
    pause
    exit /b 1
)
echo Installed "%MOD%"
echo      into "%GD_PATH%\geode\mods\"

choice /c YN /m "Start Geometry Dash now"
if errorlevel 2 exit /b 0
start "" "steam://rungameid/322170"
