@setlocal

set TARGETDIR=D:\build

@rem Initialize build environment of Visual Studio 2015
call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat"

set PATH=%PATH%;d:\work\github\SoftHSMv2\build\perl\perl\bin

@rem Delete output directories
rmdir /S /Q %TARGETDIR%\src\openssl-1.0.2g-x86
rmdir /S /Q %TARGETDIR%\bin\openssl-1.0.2g-x86

@rem Extract source code archive
"C:\Program Files\7-Zip\7z" x openssl-1.0.2g.tar.gz || goto :error
"C:\Program Files\7-Zip\7z" x openssl-1.0.2g.tar || goto :error
del openssl-1.0.2g.tar || goto :error
move openssl-1.0.2g %TARGETDIR%\src\openssl-1.0.2g-x86 || goto :error

@rem Build
cd %TARGETDIR%\src\openssl-1.0.2g-x86
set PATH=%PATH%;C:\nasm
perl Configure VC-WIN32 --prefix=%TARGETDIR%\bin\openssl-1.0.2g-x86 enable-static-engine || goto :error
call ms\do_nasm
nmake /f ms\nt.mak || goto :error
nmake /f ms\nt.mak test || goto :error
nmake /f ms\nt.mak install || goto :error

@echo *** BUILD SUCCESSFUL ***
@endlocal
@exit /b 0

:error
@echo *** BUILD FAILED ***
@endlocal
@exit /b 1