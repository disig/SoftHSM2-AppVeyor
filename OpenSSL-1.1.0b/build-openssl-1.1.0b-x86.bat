setlocal

set CD=%cd%
set TARGETDIR=%CD%\build

@rem Initialize build environment of Visual Studio 2015
call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat"
@echo on

@rem create build directories
mkdir %TARGETDIR%\src\
mkdir %TARGETDIR%\bin\

@rem Delete output directories
rmdir /S /Q %TARGETDIR%\src\openssl-1.1.0b-x86
rmdir /S /Q %TARGETDIR%\bin\openssl-1.1.0b-x86

@rem Delete previous build
del %CD%\openssl-1.1.0b-x86.zip

@rem Extract source code archive
"C:\Program Files\7-Zip\7z" x openssl-1.1.0b.tar.gz || goto :error
"C:\Program Files\7-Zip\7z" x openssl-1.1.0b.tar || goto :error
del openssl-1.1.0b.tar || goto :error
move openssl-1.1.0b %TARGETDIR%\src\openssl-1.1.0b-x86 || goto :error

@rem Build
cd %TARGETDIR%\src\openssl-1.1.0b-x86
set PATH=%PATH%;C:\nasm
perl Configure VC-WIN32 --prefix=%TARGETDIR%\bin\openssl-1.1.0b-x86 --openssldir=%TARGETDIR%\bin\openssl-1.1.0b-x86\ssl no-shared || goto :error
nmake || goto :error
nmake test || goto :error
nmake install || goto :error

"C:\Program Files\7-Zip\7z" a -tzip %CD%\openssl-1.1.0b-x86.zip %TARGETDIR%\bin\openssl-1.1.0b-x86 || goto :error

@echo *** BUILD SUCCESSFUL ***
endlocal
@exit /b 0

:error
@echo *** BUILD FAILED ***
endlocal
@exit /b 1