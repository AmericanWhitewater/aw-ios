#!/bin/sh

#  OpenTerminal.sh
#
#  This is a short cut hooked up to the project
#  to allow for a shortcut to open the terminal
#  CMD + Shift + T opens a new terminal
#
#  If you want this to work on your XCode Choose;
#  XCode -> Behaviors -> Edit -> Add (+)
#  Name it, Select 'Run' and choose this file to be run
#  then assign a shortcut you want to use

open -a Terminal "$SRCROOT"
