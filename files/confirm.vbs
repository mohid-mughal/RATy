' Sends specific keys to getter in order to automatically allow the changes in reg (when win asks to confirm changes after reg is ran)
Set ws = CreateObject("wscript.shell")

wscript.sleep(1000)
ws.sendkeys "%y" ' SENDS ALT+Y  -  ALT == %
wscript.sleep(500)
ws.sendkeys "%y" ' SENDS ALT+Y  -  ALT == %
wscript.sleep(500)
ws.sendkeys "{ENTER}" ' SENDS Enter Key


