<#
.SYNOPSIS
  Download cygwin setup.exe and packages.

.PARAMETER <Parameter_Name>
    <Brief description of parameter input required. Repeat this attribute if required>

.EXAMPLE
  powershell Download-Cygwin.ps1
  
.EXAMPLE
  powershell Download-Cygwin.ps1 -PackageList PackageList.txt  
#>

param(
  [string]
  $packageList = (Join-Path (Split-Path -Parent -Path $MyInvocation.MyCommand.Definition) "PackageList.txt"),
  
  [string]
  $workingDirectory = (Join-Path (Split-Path -Parent -Path $MyInvocation.MyCommand.Definition) "WorkingDirectory"),
  
  [string]
  $setupExeUrl = "https://www.cygwin.com/setup-x86_64.exe"
)

$downloader = New-Object System.Net.WebClient

$fileName = Split-Path $setupExeUrl -Leaf
$downloadPath = Join-Path $workingDirectory $fileName
$packageDirectory = Join-Path $workingDirectory "Packages"

if(-not (Test-Path -Path $workingDirectory))
{
    New-Item -ItemType directory -Path $workingDirectory
}

if(-not (Test-Path -Path $packageDirectory))
{
    New-Item -ItemType directory -Path $packageDirectory
}

Push-Location $workingDirectory

if (-not (Test-Path $downloadPath))
{
    Write-Host "Download $setupExeUrl to $downloadPath"
    $downloader.DownloadFile($setupExeUrl, $downloadPath)
    Write-Host "Done."
}

$packageNames = (Get-Content -Path $packageList) -join ","

Write-Host "Download and install packages: $packageNames"
& $downloadPath -q -P $packageNames --local-package-dir $packageDirectory | Out-Default
Write-Host "Done."

Pop-Location