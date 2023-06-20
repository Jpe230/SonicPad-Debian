#!/bin/bash

# Taken from this repository: https://github.com/wcarhart/willcarh.art-snippets

VERBOSE=1
spinner_pid=
SHELLTRAP=/dev/null

if [ "$VERBOSE" -eq "1" ]; then
    SHELLTRAP=/dev/stdout
    function start_spinner {
        echo $1
    }
    function stop_spinner {
        :
    }
else
    function start_spinner {
        set +m
        echo -n "$1         "
        { while : ; do for X in '  •     ' '   •    ' '    •   ' '     •  ' '      • ' '     •  ' '    •   ' '   •    ' '  •     ' ' •      ' ; do echo -en "\b\b\b\b\b\b\b\b$X" ; sleep 0.1 ; done ; done & } 2>/dev/null
        spinner_pid=$!
    }

    function stop_spinner {
        { kill -9 $spinner_pid && wait; } 2>/dev/null
        set -m
        echo -en "\033[2K\r"
    }

    trap stop_spinner EXIT
fi


