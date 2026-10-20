@echo off
rem Opens the reconstructed project directly. Choosing a project in Unity 4.3's Project
rem Wizard makes the editor relaunch itself, and that relaunch crashes on Windows 10/11
rem (LicenseInfo::~LicenseInfo in Editor.log). Passing -projectPath avoids the relaunch.
set "HERE=%~dp0"
start "" "%HERE%..\UnitySetup-4.3.2\Unity.exe" -projectPath "%HERE%GangBeasts"
