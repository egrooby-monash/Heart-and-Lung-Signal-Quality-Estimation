@echo off
set MATLAB=C:\PROGRA~1\MATLAB\R2011b
set MATLAB_ARCH=win64
set MATLAB_BIN="C:\Program Files\MATLAB\R2011b\bin"
set ENTRYPOINT=mexFunction
set OUTDIR=C:\Users\sedm3697\Dropbox\DPhil\Matlab\Final_Matlab_Code\Signal Quality\Signal Quality Features\sampen\codegen\mex\sampenc\
set LIB_NAME=sampenc_mex
set MEX_NAME=sampenc_mex
set MEX_EXT=.mexw64
call mexopts.bat
echo # Make settings for sampenc > sampenc_mex.mki
echo COMPILER=%COMPILER%>> sampenc_mex.mki
echo COMPFLAGS=%COMPFLAGS%>> sampenc_mex.mki
echo OPTIMFLAGS=%OPTIMFLAGS%>> sampenc_mex.mki
echo DEBUGFLAGS=%DEBUGFLAGS%>> sampenc_mex.mki
echo LINKER=%LINKER%>> sampenc_mex.mki
echo LINKFLAGS=%LINKFLAGS%>> sampenc_mex.mki
echo LINKOPTIMFLAGS=%LINKOPTIMFLAGS%>> sampenc_mex.mki
echo LINKDEBUGFLAGS=%LINKDEBUGFLAGS%>> sampenc_mex.mki
echo MATLAB_ARCH=%MATLAB_ARCH%>> sampenc_mex.mki
echo BORLAND=%BORLAND%>> sampenc_mex.mki
echo OMPFLAGS= >> sampenc_mex.mki
echo OMPLINKFLAGS= >> sampenc_mex.mki
echo EMC_COMPILER=msvc100free>> sampenc_mex.mki
echo EMC_CONFIG=debug>> sampenc_mex.mki
"C:\Program Files\MATLAB\R2011b\bin\win64\gmake" -B -f sampenc_mex.mk
