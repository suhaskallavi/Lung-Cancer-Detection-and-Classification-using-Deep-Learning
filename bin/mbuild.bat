@echo off
rem MBUILD.BAT
rem Compile and link tool 

rem Check environment variable and then decide whether to execute 
rem old MBUILD (mbuild version 1) or new MBUILD (mbuild version 2)
if "%MBUILD_VERSION1%" == ""  goto MBUILD_VERSION2
if "%MBUILD_VERSION1%" == "0" goto MBUILD_VERSION2

SETLOCAL
set PERLLIB=
set PERL5LIB=
set PERL5OPT=
set PERL5SHELL=
"%~dp0\..\sys\perl\win32\bin\perl.exe" "%~dp0\mex.pl" -mb %*
ENDLOCAL
goto DONE  

:MBUILD_VERSION2
rem Entering mbuild version 2. Decide the bit-ness of 
rem mex.exe file to be executed

if "%PROCESSOR_ARCHITECTURE%" == "AMD64" (
  set MEXARCH=win64
) else if "%PROCESSOR_ARCHITEW6432%" == "AMD64" (
  set MEXARCH=win64
) else (
  set MEXARCH=win32
)

if %MEXARCH% == win64 (

if not exist "%~dp0\win64" (
   set MEXARCH=win32
)
)

rem This is useful when -win32 flag is provided  
rem along with MCC to develop 32 bit application
rem Switch between creating a shared library, executable or COM components.
for %%i in (%1 %2 %3) do (
if "%%i"=="-win32" (set MEXARCH=win32
)
if "%%i"=="mbuild" goto :buildLibrary
if "%%i"=="mbuild_com" goto :buildCOM
)

goto :buildEXE

:buildLibrary
:buildCOM

"%~dp0\%MEXARCH%\mex.exe" -largeArrayDims %*
goto DONE  

:buildEXE
"%~dp0\%MEXARCH%\mex.exe" -largeArrayDims -client mbuild %* 
goto DONE

:DONE
"%SystemRoot%\system32\cmd" /c exit %errorlevel%