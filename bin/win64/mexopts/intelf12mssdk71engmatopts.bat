@echo off  
rem INTELF12MSSDK71ENGMATOPTS.BAT
rem
rem    Compile and link options used for building stand-alone engine or MAT
rem    programs using the Intel? Visual Fortran Compiler 12.0 with the
rem    Microsoft Software Development Kit linker.
rem    
rem    $Revision: 1.1.8.1 $  $Date: 2011/12/16 15:12:36 $
rem
rem ********************************************************************
rem General parameters
rem ********************************************************************
set MATLAB=%MATLAB%
set IFORT_COMPILER12=%IFORT_COMPILER12%
set VSINSTALLDIR=%VS100COMNTOOLS%\..\..
set VCINSTALLDIR=%VSINSTALLDIR%\VC
rem In this case, LINKERDIR is being used to specify the location of the SDK
set LINKERDIR='.registry_lookup("SOFTWARE\Microsoft\Microsoft SDKs\Windows\v7.1" , "InstallationFolder").'
set PATH=%IFORT_COMPILER12%\Bin\Intel64;%VCINSTALLDIR%\bin\amd64;%LINKERDIR%\bin\x64;%VCINSTALLDIR%\BIN;%VSINSTALLDIR%\Common7\Tools;%VSINSTALLDIR%\Common7\Tools\bin;%MATLAB_BIN%;%PATH%
set INCLUDE=%IFORT_COMPILER12%\compiler\Include;%LINKERDIR%\include;%VCINSTALLDIR%\ATLMFC\INCLUDE;%VCINSTALLDIR%\INCLUDE;%VCINSTALLDIR%\VCPackages;%INCLUDE%
set LIB=%IFORT_COMPILER12%\compiler\Lib\Intel64;%LINKERDIR%\LIB\x64;%VCINSTALLDIR%\LIB\amd64;%VCINSTALLDIR%\ATLMFC\LIB\amd64;%MATLAB%\extern\lib\win64;%LIB%
set MW_TARGET_ARCH=win64

rem ********************************************************************
rem Compiler parameters
rem ********************************************************************
set COMPILER=ifort
set COMPFLAGS=/fpp /Qprec /I"%MATLAB%/extern/include" /c /nologo /fixed /fp:source /MD /assume:bscc
set OPTIMFLAGS=/O2 /DNDEBUG
set DEBUGFLAGS=/Z7
set NAME_OBJECT=/Fo

rem ********************************************************************
rem Linker parameters
rem ********************************************************************
set LIBLOC=%MATLAB%\extern\lib\win64\microsoft
set LINKER=link
set LINKFLAGS=/LIBPATH:"%LIBLOC%" libmx.lib libmat.lib libeng.lib /manifest /nologo /subsystem:console
set LINKOPTIMFLAGS=
set LINKDEBUGFLAGS=/debug /PDB:"%OUTDIR%%MEX_NAME%.pdb" /INCREMENTAL:NO
set LINK_FILE=
set LINK_LIB=
set NAME_OUTPUT=/out:"%OUTDIR%%MEX_NAME%.exe"
set RSP_FILE_INDICATOR=@

rem ********************************************************************
rem Resource compiler parameters
rem ********************************************************************
set RC_COMPILER=
set RC_LINKER=
set POSTLINK_CMDS1=mt -outputresource:"%OUTDIR%%MEX_NAME%.exe";1 -manifest "%OUTDIR%%MEX_NAME%.exe.manifest" 
set POSTLINK_CMDS2=del "%OUTDIR%%MEX_NAME%.exe.manifest" 
