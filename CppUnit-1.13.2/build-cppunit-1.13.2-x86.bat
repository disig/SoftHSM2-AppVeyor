@setlocal

set TARGETDIR=D:\build

@rem Initialize build environment of Visual Studio 2015
call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat"

@rem Delete output directories
rmdir /S /Q %TARGETDIR%\src\cppunit-1.13.2-x86
rmdir /S /Q %TARGETDIR%\bin\cppunit-1.13.2-x86

@rem Extract source code archive
"C:\Program Files\7-Zip\7z" x cppunit-1.13.2.tar.gz || goto :error
"C:\Program Files\7-Zip\7z" x cppunit-1.13.2.tar || goto :error
del cppunit-1.13.2.tar || goto :error
move cppunit-1.13.2 %TARGETDIR%\src\cppunit-1.13.2-x86 || goto :error

@rem Build source code
msbuild %TARGETDIR%\src\cppunit-1.13.2-x86\src\CppUnitLibraries2010.sln ^
/p:Configuration="Release Unicode" /p:Platform="Win32" /p:PlatformToolset=v140 ^
/target:Rebuild || goto :error

@rem Copy build output
mkdir %TARGETDIR%\bin\cppunit-1.13.2-x86\lib || goto :error
xcopy %TARGETDIR%\src\cppunit-1.13.2-x86\lib %TARGETDIR%\bin\cppunit-1.13.2-x86\lib /E || goto :error
mkdir %TARGETDIR%\bin\cppunit-1.13.2-x86\include || goto :error
xcopy %TARGETDIR%\src\cppunit-1.13.2-x86\include %TARGETDIR%\bin\cppunit-1.13.2-x86\include /E || goto :error

@echo *** BUILD SUCCESSFUL ***
@endlocal
@exit /b 0

:error
@echo *** BUILD FAILED ***
@endlocal
@exit /b 1