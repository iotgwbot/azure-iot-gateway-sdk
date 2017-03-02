@REM Copyright (c) Microsoft. All rights reserved.
@REM Licensed under the MIT license. See LICENSE file in the project root for full license information.

@setlocal EnableExtensions EnableDelayedExpansion
@echo off

set current-folder=%~dp0

rem Remove trailing slash
set current-folder=%current-folder:~0,-1%

set build-root=%current-folder%\..\build\
set root=%current-folder%\..\

rem Resolve to fully qualified path
for %%i in ("%build-root%") do set build-root=%%~fi
for %%i in ("%root%") do set root=%%~fi

rem -----------------------------------------------------------------------------
rem -- Build the .NET runtime.
rem -----------------------------------------------------------------------------
set build_error=0
echo Y | call %root%\tools\build_dotnet.cmd --config=Release
if %errorlevel% neq 0 set build_error=1
echo .NET Projects Build Error: %build_error%
if %build_error% neq 0 exit /b 1

rem -----------------------------------------------------------------------------
rem -- Build the NODE runtime.
rem -----------------------------------------------------------------------------
echo Y | call %root%\tools\build_nodejs.cmd
if %errorlevel% neq 0 set build_error=1
echo NODE Runtime Build Error: %build_error%
if %build_error% neq 0 exit /b 1

rem -----------------------------------------------------------------------------
rem -- Set the NODE variables.
rem -----------------------------------------------------------------------------
set NODE_INCLUDE=%root%\build_nodejs\dist\inc\ & set NODE_LIB=%root%\build_nodejs\dist\lib\

rem -----------------------------------------------------------------------------
rem -- Build the GW core runtime with all valid bindings.
rem -----------------------------------------------------------------------------
echo Y | call %root%\tools\build.cmd --config=Release --enable-nodejs-binding --enable-dotnet-binding --enable-java-binding
if %errorlevel% neq 0 set build_error=1
echo Gateway Core Build Error: %build_error%
if %build_error% neq 0 exit /b 1

rem -----------------------------------------------------------------------------
rem -- Build the NPM packages for Windows.
rem -----------------------------------------------------------------------------
rem echo Y | call %root%\tools\codesign_core.cmd --config=Release
rem if %errorlevel% neq 0 set build_error=1
rem echo Code Sign for Core Error: %build_error%
rem if %build_error% neq 0 exit /b 1

rem -----------------------------------------------------------------------------
rem -- Build the NPM packages for Windows.
rem -----------------------------------------------------------------------------
echo Y | call %root%\tools\build_npm_win.cmd --config=Release
if %errorlevel% neq 0 set build_error=1
echo NPM packages Build Error: %build_error%
if %build_error% neq 0 exit /b 1

rem -----------------------------------------------------------------------------
rem -- Publish the NPM package to Myget as preview.
rem -----------------------------------------------------------------------------

rem -----------------------------------------------------------------------------
rem -- Publish the NPM package to NPMJS.
rem -----------------------------------------------------------------------------

@endlocal

goto :eof
