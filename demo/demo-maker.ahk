; --------------------------------------------------
; This script generates the demo gif
; --------------------------------------------------
#SingleInstance Force
SetkeyDelay 0, 50

Commands := []
Index := 1

Commands.Push("cd /vagrant/gems/menu_commander/demo")
Commands.Push("ls *.yml")
Commands.Push("cat menu.yml")
Commands.Push("menu")
Commands.Push("menu")
Commands.Push("exit")

F12::
  Send % Commands[Index]
  Index := Index + 1
return

^F12::
  Reload
return

^x::
  ExitApp
return
