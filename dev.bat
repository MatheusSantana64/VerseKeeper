@echo off
setlocal
cd /d "%~dp0"

set "FLUTTER_BAT="
for /f "delims=" %%i in ('where flutter.bat 2^>nul') do if not defined FLUTTER_BAT set "FLUTTER_BAT=%%i"
if not defined FLUTTER_BAT set "FLUTTER_BAT=C:\Users\mathe\develop\flutter\bin\flutter.bat"

if not exist "%FLUTTER_BAT%" (
    echo ERROR: could not find flutter.bat at:
    echo   %FLUTTER_BAT%
    echo Edit dev.bat and fix the FLUTTER_BAT path for your machine.
    pause
    exit /b 1
)

echo Starting VerseKeeper in debug mode with hot reload...
echo   r = hot reload    R = hot restart    q = quit
echo.

call "%FLUTTER_BAT%" run -d windows

echo.
echo flutter run exited - check the messages above.
pause
