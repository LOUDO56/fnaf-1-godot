@echo off
setlocal EnableExtensions EnableDelayedExpansion

set "SCRIPT_DIR=%~dp0"
if "%SCRIPT_DIR:~-1%"=="\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"
for %%P in ("%SCRIPT_DIR%") do set "PROJECT_ROOT=%%~dpP"
if "%PROJECT_ROOT:~-1%"=="\" set "PROJECT_ROOT=%PROJECT_ROOT:~0,-1%"

set "MAP_FILE=%SCRIPT_DIR%\assets_map.txt"
set "IMAGES_DIR=%SCRIPT_DIR%\Images"
set "SOUNDS_DIR=%SCRIPT_DIR%\Sounds"
set "ORPHAN_FILE=%TEMP%\assets_importer_orphans.txt"

set "VERBOSE=0"
set "KEEP=0"
set "ABORT_MSG="
set "USAGE_EXIT=0"

for /f %%E in ('echo prompt $E ^| cmd') do set "ESC=%%E"
if defined NO_COLOR (
    set "C_RESET="
    set "C_RED="
    set "C_GREEN="
    set "C_YELLOW="
    set "C_BLUE="
    set "C_GRAY="
    set "C_BOLD="
) else (
    set "C_RESET=!ESC![0m"
    set "C_RED=!ESC![1;31m"
    set "C_GREEN=!ESC![1;32m"
    set "C_YELLOW=!ESC![1;33m"
    set "C_BLUE=!ESC![1;34m"
    set "C_GRAY=!ESC![90m"
    set "C_BOLD=!ESC![1m"
)
set "RULE=------------------------------------------------------------"

:parse_args
if "%~1"=="" goto args_done
set "ARG=%~1"
if /i "!ARG!"=="-v" (
    set "VERBOSE=1"
    shift
    goto parse_args
)
if /i "!ARG!"=="/v" (
    set "VERBOSE=1"
    shift
    goto parse_args
)
if /i "!ARG!"=="--verbose" (
    set "VERBOSE=1"
    shift
    goto parse_args
)
if /i "!ARG!"=="-k" (
    set "KEEP=1"
    shift
    goto parse_args
)
if /i "!ARG!"=="/k" (
    set "KEEP=1"
    shift
    goto parse_args
)
if /i "!ARG!"=="--keep" (
    set "KEEP=1"
    shift
    goto parse_args
)
if /i "!ARG!"=="-h" goto usage
if /i "!ARG!"=="/h" goto usage
if /i "!ARG!"=="/?" goto usage
if /i "!ARG!"=="--help" goto usage
echo Unknown option: !ARG!
echo.
set "USAGE_EXIT=2"
goto usage

:usage
echo Usage: assets_importer.bat [options]
echo.
echo Copies every asset listed in assets_map.txt from Images\ and Sounds\ to its
echo location inside the Godot project, then removes both source folders.
echo.
echo Options:
echo   -v, --verbose   print one line per imported asset
echo   -k, --keep      keep Images\ and Sounds\ instead of deleting them
echo   -h, --help      show this help
exit /b %USAGE_EXIT%

:args_done

echo.
echo %C_BOLD%FNaF asset importer%C_RESET%
echo %C_GRAY%%RULE%%C_RESET%
call :info "Project  : %PROJECT_ROOT%"
call :info "Source   : %SCRIPT_DIR%"

if not exist "%PROJECT_ROOT%\project.godot" (
    set "ABORT_MSG=project.godot not found in %PROJECT_ROOT%, this script must stay inside the Godot project."
    goto abort
)
if not exist "%MAP_FILE%" (
    set "ABORT_MSG=Mapping file not found: %MAP_FILE%"
    goto abort
)
if not exist "%IMAGES_DIR%\" (
    set "ABORT_MSG=Folder not found: %IMAGES_DIR%"
    goto abort
)
if not exist "%SOUNDS_DIR%\" (
    set "ABORT_MSG=Folder not found: %SOUNDS_DIR%"
    goto abort
)

set "TOTAL=0"
for /f "usebackq eol=# tokens=1,* delims=|" %%A in ("%MAP_FILE%") do (
    if not "%%B"=="" set /a TOTAL+=1
)
if "%TOTAL%"=="0" (
    set "ABORT_MSG=Mapping file is empty: %MAP_FILE%"
    goto abort
)

call :info "Assets to import: %TOTAL%"

if exist "%ORPHAN_FILE%" del /q "%ORPHAN_FILE%" >nul 2>&1

set "COPIED=0"
set "COPIED_IMAGES=0"
set "COPIED_SOUNDS=0"
set "MISSING=0"
set "FAILED=0"
set "ORPHAN=0"
set "PROCESSED=0"
set "NEXT_STEP=10"

echo.
echo %C_BOLD%Importing%C_RESET%
echo %C_GRAY%%RULE%%C_RESET%

for /f "usebackq eol=# tokens=1,* delims=|" %%A in ("%MAP_FILE%") do call :import_asset "%%A" "%%B"

if %ORPHAN% gtr 0 (
    echo.
    echo %C_BOLD%Assets without a .import file%C_RESET%
    echo %C_GRAY%%RULE%%C_RESET%
    for /f "usebackq delims=" %%L in ("%ORPHAN_FILE%") do call :warn "%%L - Godot will regenerate it on the next project scan"
)
if exist "%ORPHAN_FILE%" del /q "%ORPHAN_FILE%" >nul 2>&1

set "FOUND_IMAGES=0"
set "FOUND_SOUNDS=0"
for /f %%N in ('dir /b /a-d "%IMAGES_DIR%\*.png" 2^>nul ^| find /c /v ""') do set "FOUND_IMAGES=%%N"
for /f %%N in ('dir /b /a-d "%SOUNDS_DIR%\*.wav" 2^>nul ^| find /c /v ""') do set "FOUND_SOUNDS=%%N"
set /a UNUSED_IMAGES=FOUND_IMAGES-COPIED_IMAGES
set /a UNUSED_SOUNDS=FOUND_SOUNDS-COPIED_SOUNDS
if %UNUSED_IMAGES% lss 0 set "UNUSED_IMAGES=0"
if %UNUSED_SOUNDS% lss 0 set "UNUSED_SOUNDS=0"
set /a UNUSED_TOTAL=UNUSED_IMAGES+UNUSED_SOUNDS

echo.
echo %C_BOLD%Summary%C_RESET%
echo %C_GRAY%%RULE%%C_RESET%
call :stat "Imported" "%C_GREEN%%COPIED%%C_RESET%"
if %MISSING% gtr 0 call :stat "Missing sources" "%C_RED%%MISSING%%C_RESET%"
if %FAILED% gtr 0 call :stat "Write failures" "%C_RED%%FAILED%%C_RESET%"
if %ORPHAN% gtr 0 call :stat "Without .import" "%C_YELLOW%%ORPHAN%%C_RESET%"
if %UNUSED_TOTAL% gtr 0 call :stat "Unused by the project" "%C_GRAY%%UNUSED_IMAGES% images, %UNUSED_SOUNDS% sounds%C_RESET%"

set /a ERRORS=MISSING+FAILED

echo.
echo %C_BOLD%Cleanup%C_RESET%
echo %C_GRAY%%RULE%%C_RESET%
if "%KEEP%"=="1" (
    call :info "--keep used, Images\ and Sounds\ were left untouched."
    goto finish
)
if %ERRORS% gtr 0 (
    call :warn "Images\ and Sounds\ were kept because %ERRORS% asset(s) could not be imported."
    call :warn "Fix the errors above and run the script again."
    goto finish
)
rd /s /q "%IMAGES_DIR%" >nul 2>&1
rd /s /q "%SOUNDS_DIR%" >nul 2>&1
if exist "%IMAGES_DIR%\" (
    call :fail "Could not remove Images\, delete it manually."
    set /a ERRORS+=1
    goto finish
)
if exist "%SOUNDS_DIR%\" (
    call :fail "Could not remove Sounds\, delete it manually."
    set /a ERRORS+=1
    goto finish
)
call :ok "Images\ and Sounds\ removed."

:finish
echo.
if !ERRORS! gtr 0 (
    echo %C_RED%Import finished with !ERRORS! error^(s^).%C_RESET%
    echo.
    exit /b 1
)
echo %C_GREEN%%COPIED% assets imported successfully. Open the project in Godot to let it reimport them.%C_RESET%
echo.
exit /b 0

:import_asset
set "REL_SRC=%~1"
set "REL_DST=%~2"
if "!REL_DST!"=="" goto :eof
set "SRC=%SCRIPT_DIR%\!REL_SRC:/=\!"
set "DST=%PROJECT_ROOT%\!REL_DST:/=\!"
set /a PROCESSED+=1
if not exist "!SRC!" (
    set /a MISSING+=1
    call :fail "missing source: !REL_SRC!"
    goto import_progress
)
for %%D in ("!DST!") do set "DST_DIR=%%~dpD"
if not exist "!DST_DIR!" mkdir "!DST_DIR!" >nul 2>&1
copy /y "!SRC!" "!DST!" >nul 2>&1
if errorlevel 1 (
    set /a FAILED+=1
    call :fail "cannot write: !REL_DST!"
    goto import_progress
)
set /a COPIED+=1
if /i "!REL_SRC:~0,7!"=="Images/" set /a COPIED_IMAGES+=1
if /i "!REL_SRC:~0,7!"=="Sounds/" set /a COPIED_SOUNDS+=1
if "%VERBOSE%"=="1" call :ok "!REL_SRC! to !REL_DST!"
if not exist "!DST!.import" (
    set /a ORPHAN+=1
    >>"%ORPHAN_FILE%" echo !REL_DST!
)

:import_progress
if "%VERBOSE%"=="1" goto :eof
set /a PCT=PROCESSED*100/TOTAL
if !PCT! lss !NEXT_STEP! goto :eof
set /a NEXT_STEP=PCT/10*10+10
set "PAD=  !PCT!"
set "PAD=!PAD:~-3!"
echo   %C_GREEN%[!PAD!%%]%C_RESET% !PROCESSED!/%TOTAL% assets
goto :eof

:ok
set "MSG=%~1"
echo   %C_GREEN%[ OK ]%C_RESET% !MSG!
goto :eof

:fail
set "MSG=%~1"
echo   %C_RED%[FAIL]%C_RESET% !MSG!
goto :eof

:warn
set "MSG=%~1"
echo   %C_YELLOW%[WARN]%C_RESET% !MSG!
goto :eof

:info
set "MSG=%~1"
echo   %C_BLUE%[INFO]%C_RESET% !MSG!
goto :eof

:stat
set "LABEL=%~1                      "
set "LABEL=!LABEL:~0,22!"
set "VALUE=%~2"
echo   !LABEL! !VALUE!
goto :eof

:abort
echo   %C_RED%[FAIL]%C_RESET% !ABORT_MSG!
echo.
echo %C_RED%Import aborted, nothing was changed.%C_RESET%
echo.
exit /b 1
