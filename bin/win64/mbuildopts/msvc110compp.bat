@echo off
rem MSVC110COMPP.BAT
rem
rem    Compile and link options for use with MATLAB Compiler.
rem    using the Microsoft Visual C++ compiler version 11.0.
rem
rem    $Revision: 1.1.6.1 $  $Date: 2012/12/15 18:06:16 $
rem
rem ********************************************************************
rem General parameters
rem ********************************************************************

set MATLAB=%MATLAB%
set VSINSTALLDIR=%VS110COMNTOOLS%\..\..
set VCINSTALLDIR=%VSINSTALLDIR%\VC
rem In this case, LINKERDIR is being used to specify the location of the SDK
set LINKERDIR='.registry_lookup("SOFTWARE\Wow6432Node\Microsoft\Microsoft SDKs\Windows\v8.0" , "InstallationFolder").'
set PATH=%VCINSTALLDIR%\bin\amd64;%VCINSTALLDIR%\bin;%VCINSTALLDIR%\VCPackages;%VSINSTALLDIR%\Common7\IDE;%VSINSTALLDIR%\Common7\Tools;%LINKERDIR%\bin\x64;%LINKERDIR%\bin;%MATLAB_BIN%;%PATH%
set INCLUDE=%VCINSTALLDIR%\INCLUDE;%VCINSTALLDIR%\ATLMFC\INCLUDE;%LINKERDIR%\include\um;%LINKERDIR%\include\shared;%LINKERDIR%\include\winrt;%INCLUDE%
set LIB=%VCINSTALLDIR%\LIB\amd64;%VCINSTALLDIR%\ATLMFC\LIB\amd64;%LINKERDIR%\lib\win8\um\x64;%MATLAB%\extern\lib\win64;%LIB%
set PERL="%MATLAB%\sys\perl\win32\bin\perl.exe"
set MW_TARGET_ARCH=win64

rem ********************************************************************
rem Compiler parameters
rem ********************************************************************
set COMPILER=cl
set OPTIMFLAGS=-O2 -DNDEBUG
set DEBUGFLAGS=-Z7
set VER_SPECIFIC_OPTS=/D_CRT_SECURE_NO_DEPRECATE
set CPPOPTIMFLAGS=-O2 -DNDEBUG
set CPPDEBUGFLAGS=-Z7
set COMPFLAGS=-MD -c -Zp8 -GR -W3 -EHsc- -Zc:wchar_t- -nologo %VER_SPECIFIC_OPTS%
set CPPCOMPFLAGS=-MD -c -Zp8 -GR -W3 -EHsc- -Zc:wchar_t- -nologo -I"%MATLAB%\extern\include\win64" -DMSVC -DIBMPC /D_SECURE_SCL=0 %VER_SPECIFIC_OPTS%
set DLLCOMPFLAGS=-MD -c -Zp8 -GR -EHsc- -Zc:wchar_t- -W3 -nologo -I"%MATLAB%\extern\include\win64" -DMSVC -DIBMPC %VER_SPECIFIC_OPTS%
set NAME_OBJECT=/Fo

rem ********************************************************************
rem Library creation commands creating import and export libraries
rem ********************************************************************
set DLL_MAKEDEF=type %BASE_EXPORTS_FILE% | %PERL% -e "print \"LIBRARY %MEX_NAME%.dll\nEXPORTS\n\"; while (<>) {print;}" > "%DEF_FILE%"

rem ********************************************************************
rem Linker parameters
rem ********************************************************************
set LIBLOC=%MATLAB%\extern\lib\win64\microsoft
set LINKER=link
set MANIFEST_FILE_NAME=%OUTDIR%%MEX_NAME%.msvc.manifest
set LINKFLAGS=/MACHINE:AMD64 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /LIBPATH:"%LIBLOC%" /nologo /manifest /manifestfile:"%MANIFEST_FILE_NAME%" 
set LINKFLAGS=%LINKFLAGS% mclmcrrt.lib %MCR_DELAYLIB% %MCR_DELAYLOAD%
set CPPLINKFLAGS=
set DLLLINKFLAGS= %LINKFLAGS% /dll /implib:"%OUTDIR%%MEX_NAME%.lib" /def:"%DEF_FILE%"
set HGLINKFLAGS=
set LINKOPTIMFLAGS=
set LINKDEBUGFLAGS=/debug
set LINK_FILE=
set LINK_LIB=
set EXE_OUTPUT_NAME="%OUTDIR%%MEX_NAME%.exe"
set DLL_OUTPUT_NAME="%OUTDIR%%MEX_NAME%.dll"
set NAME_OUTPUT=/out:%EXE_OUTPUT_NAME%
set DLL_NAME_OUTPUT=/out:%DLL_OUTPUT_NAME%
set RSP_FILE_INDICATOR=@

rem ********************************************************************
rem Resource compiler parameters
rem ********************************************************************
set RC_COMPILER=rc /fo "%OUTDIR%%RES_NAME%.res"
set RC_LINKER= 

rem ********************************************************************
rem IDL Compiler
rem ********************************************************************
set IDL_COMPILER=midl /nologo /win64 /I "%MATLAB%\extern\include" 
set IDL_OUTPUTDIR= /out "%OUTDIRN%"
set IDL_DEBUG_FLAGS= /D "_DEBUG" 
set IDL_OPTIM_FLAGS= /D "NDEBUG" 
rem ********************************************************************
rem Post link. Under MSVC 11, the runtime must be loaded by a manifest file.
rem ********************************************************************
set EXE_MANIFEST_RESOURCE=1
set DLL_MANIFEST_RESOURCE=2
set POSTLINK_CMDS1="if exist %LIB_NAME%.def del %LIB_NAME%.def"
set POSTLINK_CMDS2=mt.exe -outputresource:%MBUILD_OUTPUT_FILE_NAME%;%MANIFEST_RESOURCE% -manifest "%MANIFEST_FILE_NAME%"
set POSTLINK_CMDS3=del "%MANIFEST_FILE_NAME%"
