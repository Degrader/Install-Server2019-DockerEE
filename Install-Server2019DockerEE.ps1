#Requires -RunAsAdministrator

#Check to see if Hyper-V is installed
if ((Get-WindowsFeature Hyper-V).Installed -eq 0){
    $installFeatures += "Hyper-V"
    Write-Host "Hyper-V will be installed"
    }

#Check to see if Containers is installed
if ((Get-WindowsFeature Containers).Installed -eq 0){
    $installFeatures += "Containers"
    Write-Host "Containers will be installed"
    }

#Install missing features if any, and restart
if ($installFeatures -ne $null -and $InstallFeatures -ne ""){
    Write-Host "Installing necessary features..."
    Install-WindowsFeature $installFeatures
    Restart-Computer -Force
}

#Install module for Docker EE
Install-Module -Name DockerMsftProvider -Repository PSGallery -Force

#Install Docker EE 18.09 <version index available "https://dockermsft.blob.core.windows.net/dockercontainer/DockerMsftIndex.json">
Install-Package Docker -ProviderName DockerMsftProvider -RequiredVersion 18.09 -Update -Force

#Set Docker service to run experimental features
Set-ItemProperty -Path HKLM:\system\CurrentControlSet\Services\Docker\ -Name ImagePath -Value """C:\Program Files\Docker\dockerd.exe"" --run-service --experimental"

#Get latest Linux Kit LCOW
#if SSL/TLS error: [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri "https://github.com/linuxkit/lcow/releases/download/v4.14.35-v0.3.9/release.zip" -OutFile "$env:TEMP\LCOWRelease.zip"

#Extract LCOW to Program Files for Docker
Expand-Archive -Path "$env:TEMP\LCOWRelease.zip" -DestinationPath "C:\Program Files\Linux Containers"

Start-Service Docker





<#Getting Started Notes:
   #Pull down Server Core 1809 image
    docker image pull mcr.microsoft.com/windows/servercore:1809

   #Pull down Server Nano 1809 image
    docker image pull mcr.microsoft.com/windows/nanoserver:1809

   #Pull down .NET Core Images
    docker image pull microsoft/dotnet:2.1-sdk-nanoserver-1809
    docker image pull microsoft/dotnet:2.1-aspnetcore-runtime-nanoserver-1809 

#>
