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
rmdir /s/q %build-root%\az-iot-gw
rmdir /s/q %build-root%\az-iot-gw-module-js
mkdir %build-root%\az-iot-gw
mkdir %build-root%\az-iot-gw-module-js

pushd %build-root%

rem Copy package definition files into npm folder.
xcopy %root%\dist_pkgs\npm\az-iot-gw .\az-iot-gw /S /Q
xcopy %root%\dist_pkgs\npm\az-iot-gw-module-js .\az-iot-gw-module-js /S /Q
copy %root%\LICENSE.txt az-iot-gw\LICENSE
copy %root%\LICENSE.txt az-iot-gw-module-js\LICENSE

rem copy files for azure iot gateway module development.
mkdir az-iot-gw-module-js\samples\simple\modules
xcopy %root%\samples\nodejs_simple_sample\nodejs_modules az-iot-gw-module-js\samples\simple\modules /S /Q

popd

goto :eof
