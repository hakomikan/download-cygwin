@echo off

cd /d %~dp0

powershell -ExecutionPolicy RemoteSigned .\Download-Cygwin.ps1 %*