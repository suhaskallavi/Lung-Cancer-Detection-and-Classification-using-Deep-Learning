@echo off
rem MEMSHIELDSTARTRT.BAT
SETLOCAL
set MEMSHIELDARCH=win32
set MEMSHIELDPATH=%~dp0
if "%PROCESSOR_ARCHITECTURE%" == "AMD64" (
  set MEMSHIELDARCH=win64
) else if "%PROCESSOR_ARCHITEW6432%" == "AMD64" (
  set MEMSHIELDARCH=win64
)
if %MEMSHIELDARCH%==win64 (
  if not exist "%MEMSHIELDPATH%win64" (
    set MEMSHIELDARCH=win32
  )
)
set MWArgs=
:LOOP
if "%~1"=="" GOTO CONTINUE
if not defined MWArgs (
set MWArgs=%1
) else (
set MWArgs=%MWArgs% %1
)
shift
goto LOOP
:CONTINUE
if %MEMSHIELDARCH%==win32 (
  if not exist "%MEMSHIELDPATH%win32" (
    @echo Unable to find a suitable install area
    set errorlevel=1
    goto DONE
  )
)
set PATH="%MEMSHIELDPATH%%MEMSHIELDARCH%";%PATH%
"%MEMSHIELDPATH%%MEMSHIELDARCH%\MemShieldStarter" %MWArgs%
:DONE
ENDLOCAL
"%SystemRoot%\system32\cmd" /c exit %errorlevel%
