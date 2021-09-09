#!/bin/bash

stat=""
task="a task"

function track {

#Starts timetracker
  if [[ "$1" == "start" ]] && [[ "$stat" != "start" ]] ; then
    echo "START $(date +"%D %T" )" >> LOGFILE
    echo "LABEL $2" >> LOGFILE
    stat="start"
    if [[ "$#" -ne 1 ]] ; then
      task="$2"
    fi
    #Stops timetracker
  elif [[ "$1" == "stop" ]] && [[ "$stat" != "stop" ]] ; then
    echo "STOP $(date +"%D %T" )" >> LOGFILE
    stat="stop"
  elif [[ "$1" == "status" ]] ; then
    if [[ "$stat" == "start" ]] ; then
      printf "\nTimer is currently counting on a task. \n\n"
    else
      printf "\nTimer is not counting on a task. \n\n"
    fi
    #Prints a log of time.
  elif [[ "$1" == "log" ]] && [[ "$stat" != "start" ]] ; then

    c=1
    while read    _ starttime   ; do
      read
      read    _ stoptime
      stopInSec=$(date -d "$stoptime" +%s)
      startInSec=$(date -d "$starttime" +%s)
      secs=$(( stopInSec - startInSec ))
      HH=$((secs/3600))
      MM=$((secs%3600/60))
      SS=$((secs%60))
      #Formatting the timer to ensure HH:MM:SS two digit each-fromat.
      if [[ $HH -lt 10 ]] ; then
        HH=0$HH
      fi
      if [[ $MM -lt 10 ]] ; then
        MM=0$MM
      fi
      if [[ $SS -lt 10 ]] ; then
        SS=0$SS
      fi
      echo Task $c: $HH:$MM:$SS
      let "c += 1"
    done < LOGFILE

  else
    #Gives error if user tries to start while timer is on, or stop if timer is off.
    if [[ "$stat" == "start" ]] ; then
    printf "\nTimer is allready started. \nPlease stop timer before starting a new. \n\n"
  elif [[ "$stat" == "stop" ]] ; then
    printf "\nTimer is not currently running. \nStart the timer with command: track start \n\n"
    fi
fi
}
