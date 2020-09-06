@echo off
rem DEPLOYTOOL.BAT
SETLOCAL
set DEPLOYTOOLARCH=win32
set DEPLOYTOOLPATH=%~dp0
if "%PROCESSOR_ARCHITECTURE%" == "AMD64" (
  set DEPLOYTOOLARCH=win64
) else if "%PROCESSOR_ARCHITEW6432%" == "AMD64" (
  set DEPLOYTOOLARCH=win64
)
if %DEPLOYTOOLARCH% == win64 (
  if not exist "%DEPLOYTOOLPATH%win64" (
    set DEPLOYTOOLARCH=win32
  )
)
set MWArgs=
:LOOP
if "%~1"=="" GOTO CONTINUE
if "%~1"=="-win32" (
  set DEPLOYTOOLARCH=win32
) else (
  if not defined MWArgs (
    set MWArgs=%1
  ) else (
    set MWArgs=%MWArgs% %1
  )
)
shift
goto LOOP
:CONTINUE
if %DEPLOYTOOLARCH%==win32 (
  if not exist "%DEPLOYTOOLPATH%win32" (
    @echo Unable to find a suitable install area
    set errorlevel=1
    goto DONE
  )
)
set PATH=%DEPLOYTOOLPATH%%DEPLOYTOOLARCH%;%PATH%
"%DEPLOYTOOLPATH%%DEPLOYTOOLARCH%\deploytool" %MWArgs%
:DONE
ENDLOCAL
"%SystemRoot%\system32\cmd" /c exit %errorlevel%
