@REM Copyright (c) Microsoft. All rights reserved.
@REM Licensed under the MIT license. See LICENSE file in the project root for full license information.

@setlocal EnableExtensions EnableDelayedExpansion
@echo off

set current-path=%~dp0

rem // remove trailing slash
set current-path=%current-path:~0,-1%

set build-root=%current-path%\..\build\dist_pkgs\npm
set root=%current-path%\..\

rem Resolve to fully qualified path
for %%i in ("%build-root%") do set build-root=%%~fi
for %%i in ("%root%") do set root=%%~fi

rem Clear the nodejs build folder so we have a fresh build
rmdir /s/q %build-root%\az-iot-gw-win
mkdir %build-root%\az-iot-gw-win\bin

pushd %build-root%

rem Copy windows package definition files into npm folder.
xcopy %root%\dist_pkgs\npm\az-iot-gw-win .\az-iot-gw-win /S /Q
copy %root%\LICENSE.txt az-iot-gw-win\LICENSE

rem copy binary files for azure iot gateway.
copy %root%\build\core\Debug\gateway.dll az-iot-gw-win\bin
copy %root%\install-deps\bin\aziotsharedutil.dll az-iot-gw-win\bin
copy %root%\install-deps\bin\\nanomsg.dll az-iot-gw-win\bin
copy %root%\build_nodejs\node\Release\node.dll az-iot-gw-win\bin
copy %root%\build\bindings\nodejs\Debug\nodejs_binding.dll az-iot-gw-win\bin
copy %root%\build\dist_pkgs\gw\Debug\gw.exe az-iot-gw-win\bin

popd

goto :eof
