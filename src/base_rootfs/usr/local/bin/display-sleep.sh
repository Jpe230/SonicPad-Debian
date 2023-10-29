#!/bin/bash

#config
delay=2 # repeat every 2 seconds

# init

read dummy dummy  former_state < <(xset -display :0 -q | grep "Monitor is ")
echo $former_state
sleep $delay

#loop
while true; do
  read dummy dummy state < <(xset -display :0 -q | grep "Monitor is ")
  echo $state
  [ "$state" = "On" ] || state="Off" # squeeze away suspend/standby, monitor is off
  if [ "$state" != "$former_state" ]; then
    if [ "$state" = "On" ]; then
        brightness -s 1
    else
        brightness -s 0
    fi
    former_state="$state"
  fi
sleep $delay
done
