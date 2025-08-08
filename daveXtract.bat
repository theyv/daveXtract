@echo off
:: Set UTF-8 to correctly display special characters
chcp 65001 > nul
setlocal EnableExtensions EnableDelayedExpansion

:: =============================================================
::  DAVE / XTRACT – Smart-Extract for 7-Zip
:: =============================================================
::  • Extracts an archive to a folder with the same name.
::  • Collision handling:  O-Overwrite  C-Cancel  M-Merge  I-Increment  Z-Open in 7-Zip.
::  • After extraction:  ENTER – delete + open folder | DEL – delete | any other key – exit CMD.
::  • Save this file in UTF-8 (without BOM).
:: =============================================================

GOTO :MAIN

:banner
echo ██████╗░░█████╗░██╗░░░██╗███████╗  ░░░░██╗  ██╗░░██╗████████╗██████╗░░█████╗░░█████╗░████████╗
echo ██╔══██╗██╔══██╗██║░░░██║██╔════╝  ░░░██╔╝  ╚██╗██╔╝╚══██╔══╝██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝
echo ██║░░██║███████║╚██╗░██╔╝█████╗░░  ░░██╔╝░  ░╚███╔╝░░░░██║░░░██████╔╝███████║██║░░╚═╝░░░██║░░░
echo ██║░░██║██╔══██║░╚████╔╝░██╔══╝░░  ░██╔╝░░  ░██╔██╗░░░░██║░░░██╔══██╗██╔══██║██║░░██╗░░░██║░░░
echo ██████╔╝██║░░██║░░╚██╔╝░░███████╗  ██╔╝░░░  ██╔╝╚██╗░░░██║░░░██║░░██║██║░░██║╚█████╔╝░░░██║░░░
echo ╚═════╝░╚═╝░░╚═╝░░░╚═╝░░░╚══════╝  ╚═╝░░░░  ╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░╚═╝╚═╝░░╚═╝░╚════╝░░░░╚═╝░░░
echo.
goto :eof

:MAIN
:: 1) Check input parameter
if "%~1"=="" (
    call :banner
    echo No archive file provided for extraction.
    timeout /t 5 > nul
    goto :EOF
)

set "ARCHIVE=%~1"
set "BASENAME=%~n1"
set "DEST=%~dp1%BASENAME%"
set "SWITCH="
set "NEEDINC="
set "OPEN_7ZIP="

:: Flag: is target on Google Drive?
set "ON_GDRIVE="
if /I "%DEST:~0,2%"=="G:" set "ON_GDRIVE=1"

:: 2) Handle target folder collisions
if exist "%DEST%\" (
    call :banner
    echo Folder "%DEST%" already exists.
    echo.
    echo  [O] Overwrite all  – replace all files
    echo  [C] Cancel         – abort operation
    echo  [M] Merge          – skip existing files
    echo  [I] Increment      – extract to next available folder
    echo  [Z] 7-Zip          – open archive in 7-Zip File Manager
    choice /C OCMIZ /N /M "Choose an option: "
    
    if errorlevel 5 (
        set "OPEN_7ZIP=1"
    ) else if errorlevel 4 (
        set "NEEDINC=1"
    ) else if errorlevel 3 (
        set "SWITCH=-aos"
    ) else if errorlevel 2 (
        goto :EOF
    ) else if errorlevel 1 (
        set "SWITCH=-aoa"
    )
)

:: 2a) Open in 7-Zip File Manager instead of extracting
if defined OPEN_7ZIP (
    call :banner
    echo Opening archive in 7-Zip File Manager...
    start "" "%ProgramFiles%\7-Zip\7zFM.exe" "%ARCHIVE%"
    goto :EOF
)

:: 2b) Increment folder name
if defined NEEDINC (
    set "BASE=%DEST%"
    set /A N=1
:INC_SEARCH
    set "SUFFIX=0!N!"
    set "SUFFIX=!SUFFIX:~-2!"
    set "DEST=!BASE!-!SUFFIX!"
    if exist "!DEST!\" (
        set /A N+=1
        goto INC_SEARCH
    )
    echo Using folder "!DEST!".
)

:: 3) Create destination folder
if not exist "!DEST!" mkdir "!DEST!"

:: 4) Extract archive
call :banner
echo Extracting archive: %~nx1
"%ProgramFiles%\7-Zip\7z.exe" x "%ARCHIVE%" -o"!DEST!" !SWITCH! -y
set "EXCODE=%ERRORLEVEL%"
echo.

:: 4a) Handle 7-Zip errors
if not "%EXCODE%"=="0" goto :EXTRACT_ERROR

:: 5) After extraction: ENTER=delete+open, DEL=delete, other=exit
call :banner
echo Press: ENTER = delete archive and open folder, DEL = delete archive, any other key = exit.
powershell -NoLogo -NoProfile -Command ^
  "$k=[Console]::ReadKey($true); if($k.Key -eq 'Enter'){exit 10} elseif($k.Key -eq 'Delete'){exit 20} else {exit 30}" > nul

if %errorlevel%==10 (
    del "%ARCHIVE%" 2>nul
    start "" explorer.exe "!DEST!"
    exit
) else if %errorlevel%==20 (
    del "%ARCHIVE%" 2>nul
    exit
) else (
    exit
)

:EXTRACT_ERROR
call :banner
echo !!! Extraction failed (exit code %EXCODE%) !!!
echo.
echo Common causes:
echo  - No permissions or files locked in target folder
if defined ON_GDRIVE echo  - Google Drive limitations (Stream mode, not available offline, cloud-only files)
echo  - Path too long or invalid characters in filenames
echo  - Antivirus/Defender blocking file creation or extraction
echo.
echo Suggestions:
if defined ON_GDRIVE (
  echo  * Right-click target folder in G:\ and choose "Available offline".
  echo  * Or switch Google Drive to "Mirror" mode (local copies of files).
)
echo  * Try extracting to a local folder (e.g. %%TEMP%%) and then copying.
echo  * Make sure Windows long path support is enabled.
echo  * Update 7-Zip to the latest version and run CMD as administrator.
echo.
echo 7-Zip exit code mapping:
echo   0=OK, 1=Warnings, 2=Fatal error, 7=Command line error,
echo   8=Not enough memory, 255=User stopped the process.
echo.
pause
endlocal
GOTO :EOF
