@REM Copyright (c) Microsoft. All rights reserved.
@REM Licensed under the MIT license. See LICENSE file in the project root for full license information.

@setlocal EnableExtensions EnableDelayedExpansion
@echo off

set current-path=%~dp0

rem Remove trailing slash
set current-path=%current-path:~0,-1%

set root=%current-path%\..
set build-root=%root%\build\dist_pkgs\maven\az-iot-gw-win

rem Resolve to fully qualified path
for %%i in ("%root%") do set root=%%~fi
for %%i in ("%build-root%") do set build-root=%%~fi

rem Build options
set build-config=Debug

if "%1" equ "" goto build-maven
if "%1" equ "--config" goto arg-build-config

:arg-build-config
shift
if "%1" equ "" call :usage && exit /b 1
set build-config=%1


:build-maven
rem Clear the build folder so we have a fresh build
rmdir /s/q %build-root%
mkdir %build-root%

pushd %build-root%

rem Copy windows package definition files into npm folder.
mkdir .\src
xcopy %root%\dist_pkgs\maven\az-iot-gw-win\src .\src /S /Q
copy %root%\dist_pkgs\maven\az-iot-gw-win\pom.xml .\pom.xml
mkdir .\src\main\resources
copy %root%\License.txt .\src\main\resources\License.txt

rem Copy binary files for azure iot gateway.
copy %root%\build\core\%build-config%\gateway.dll    .\src\main\resources
copy %root%\install-deps\bin\aziotsharedutil.dll     .\src\main\resources
copy %root%\install-deps\bin\nanomsg.dll             .\src\main\resources
copy %root%\build\bindings\java\%build-config%\java_module_host.dll .\src\main\resources
copy %root%\build\dist_pkgs\gw\%build-config%\gw.exe .\src\main\resources

rem Publish to maven local repository
call mvn clean install
if errorlevel 1 goto :eof

popd
goto :eof


:usage
echo build_maven.cmd [options]
echo options:
echo  --config value    Build configuration (e.g. [Debug], Release)
goto :eof
