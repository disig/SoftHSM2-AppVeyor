setlocal

set CD=%cd%
set TARGETDIR=%CD%\build

@rem Initialize build environment of Visual Studio 2015
call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" amd64
@echo on

@rem Create build directories
mkdir %TARGETDIR%\src\
mkdir %TARGETDIR%\bin\

@rem Delete output directories
rmdir /S /Q %TARGETDIR%\src\botan-1.10.13-x64
rmdir /S /Q %TARGETDIR%\bin\botan-1.10.13-x64

@rem Create output directory for binaries
mkdir %TARGETDIR%\bin\botan-1.10.13-x64

@rem Delete previous build
del %CD%\botan-1.10.13-x64.zip

@rem Extract source code archive
@copy Botan-1.10.13.tgz Botan-1.10.13.tar.gz || goto :error
@rename Botan-1.10.13.tgz Botan-1.10.13.orig || goto :error
"C:\Program Files\7-Zip\7z" x botan-1.10.13.tar.gz || goto :error
"C:\Program Files\7-Zip\7z" x botan-1.10.13.tgz || goto :error
del botan-1.10.13.tgz || goto :error
del botan-1.10.13.tar.gz || goto :error
move botan-1.10.13 botan-1.10.13-x64 || goto :error
move botan-1.10.13-x64 %TARGETDIR%\src\ || goto :error
@rename Botan-1.10.13.orig Botan-1.10.13.tgz || goto :error

@rem Build
cd %TARGETDIR%\src\botan-1.10.13-x64

python configure.py --cc=msvc --cpu=x64 --prefix=%TARGETDIR%\bin\botan-1.10.13-x64 || goto :error
nmake || goto :error
nmake check || goto :error
check --validate || goto :error
nmake install || goto :error

"C:\Program Files\7-Zip\7z" a -tzip %CD%\botan-1.10.13-x64.zip %TARGETDIR%\bin\botan-1.10.13-x64 || goto :error

@echo *** BUILD SUCCESSFUL ***
endlocal
@exit /b 0

:error
@echo *** BUILD FAILED ***
endlocal
@exit /b 1