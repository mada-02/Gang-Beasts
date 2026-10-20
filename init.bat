@echo off
rem Adds the portable programs to PATH for this cmd session only (temporary).
rem Usage: run "init.bat" from cmd, or "call init.bat" from another script.

set "ROOT=%~dp0"
if "%ROOT:~-1%"=="\" set "ROOT=%ROOT:~0,-1%"

set "NODE_HOME=%ROOT%\node-v24.22.0-win-x64\node-v24.22.0-win-x64"
set "GIT_HOME=%ROOT%\PortableGit-2.55.0.5-64-bit.7z"

set "PATH=%NODE_HOME%;%GIT_HOME%\cmd;%GIT_HOME%\mingw64\bin;%GIT_HOME%\usr\bin;%PATH%"

echo Portable tools added to PATH for this session:
echo   Node: %NODE_HOME%
echo   Git:  %GIT_HOME%
node --version
git --version
