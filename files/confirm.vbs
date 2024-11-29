@@ -0,0 +1,8 @@

Set ws = CreateObject("wscript.shell")

wscript.sleep(1000)
ws.sendkeys("%y")  ' SENDS ALT+Y  -  ALT == %
wscript.sleep(500)
ws.sendkeys("%y")  ' SENDS ALT+Y  -  ALT == %
wscript.sleep(500)
ws.sendkeys("{ENTER}")  ' SENDS Enter Key