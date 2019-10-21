; --------------------------------------------------
; This script generates the demo svg
; --------------------------------------------------
#SingleInstance Force
SetkeyDelay 0, 50

Commands := []
Index := 1

Commands.Push("rm cast.json {;} asciinema rec cast.json")
Commands.Push("{#} This directory has two menu configuration files:")
Commands.Push("ls *.yml")

Commands.Push("{#} This is how a simple menu looks like:")
Commands.Push("cat menu.yml")

Commands.Push("{#} Run the menu (using the default menu.yml file)")
Commands.Push("menu")

Commands.Push("{#} A more realistic example:")
Commands.Push("cat advanced.yml")

Commands.Push("{#} Run it in dry run (without executing commands)")
Commands.Push("menu advanced --dry --loop")

Commands.Push("{#} The demo YAML files are in the demo folder")
Commands.Push("exit")
Commands.Push("cat cast.json | svg-term --out cast.svg --window")

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
