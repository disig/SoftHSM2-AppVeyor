setlocal

set CD=%cd%
set TARGETDIR=%CD%\build

@rem Initialize build environment of Visual Studio 2015
call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat"
@echo on

@rem Create build directories
mkdir %TARGETDIR%\src\
mkdir %TARGETDIR%\bin\

@rem Delete output directories
rmdir /S /Q %TARGETDIR%\src\botan-1.11.32-x86
rmdir /S /Q %TARGETDIR%\bin\botan-1.11.32-x86

@rem Create output directory for binaries
mkdir %TARGETDIR%\bin\botan-1.11.32-x86

@rem Delete previous build
del %CD%\botan-1.11.32-x86.zip

@rem Extract source code archive
@copy Botan-1.11.32.tgz Botan-1.11.32.tar.gz || goto :error
@rename Botan-1.11.32.tgz Botan-1.11.32.orig || goto :error
"C:\Program Files\7-Zip\7z" x botan-1.11.32.tar.gz || goto :error
"C:\Program Files\7-Zip\7z" x botan-1.11.32.tgz || goto :error
del botan-1.11.32.tgz || goto :error
del botan-1.11.32.tar.gz || goto :error
move botan-1.11.32 botan-1.11.32-x86 || goto :error
move botan-1.11.32-x86 %TARGETDIR%\src\ || goto :error
@rename Botan-1.11.32.orig Botan-1.11.32.tgz || goto :error

@rem Build
cd %TARGETDIR%\src\botan-1.11.32-x86

python configure.py --cc=msvc --cpu=x86 --prefix=%TARGETDIR%\bin\botan-1.11.32-x86 || goto :error
nmake || goto :error
botan-test || goto :error

@rem Gather output
mkdir %TARGETDIR%\bin\botan-1.11.32-x86\bin\ || goto :error
mkdir %TARGETDIR%\bin\botan-1.11.32-x86\lib\ || goto :error
mkdir %TARGETDIR%\bin\botan-1.11.32-x86\include\ || goto :error
copy botan-cli.exe %TARGETDIR%\bin\botan-1.11.32-x86\bin\ || goto :error
copy botan.dll %TARGETDIR%\bin\botan-1.11.32-x86\bin\ || goto :error
copy botan.lib %TARGETDIR%\bin\botan-1.11.32-x86\lib\ || goto :error
xcopy /S /E build\include\botan %TARGETDIR%\bin\botan-1.11.32-x86\include\ || goto :error

"C:\Program Files\7-Zip\7z" a -tzip %CD%\botan-1.11.32-x86.zip %TARGETDIR%\bin\botan-1.11.32-x86 || goto :error


@echo *** BUILD SUCCESSFUL ***
endlocal
@exit /b 0

:error
@echo *** BUILD FAILED ***
endlocal
@exit /b 1