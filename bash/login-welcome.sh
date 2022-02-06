#!/bin/bash
#
# This script produces a dynamic welcome message
# it should look like
#   Welcome to planet hostname, title name!

# Task 1: Use the variable $USER instead of the myname variable to get your name
# Task 2: Dynamically generate the value for your hostname variable using the hostname command - e.g. $(hostname)
# Task 3: Add the time and day of the week to the welcome message using the format shown below
#   Use a format like this:
#   It is weekday at HH:MM AM.
# Task 4: Set the title using the day of the week
#   e.g. On Monday it might be Optimist, Tuesday might be Realist, Wednesday might be Pessimist, etc.
#   You will need multiple tests to set a title
#   Invent your own titles, do not use the ones from this example

messages=('its sunday so ready for prep'
          'its Monday we have meeting'
          'its Tuesday so wings night'
          'its Wednesday be at happy hours'
          'its Thursday go to game night'
          'its Friday lets party night'
          'its Saturday go for shopping')


###############
# Variables   #
###############
title=$(date +%A)
myname=$USER
hostname="myhostname"
weekday=$(date +%A)
time=$(date "+%H:%M %p")
###############
# Main        #
###############
VAR1=`cat <<EOF
It is $weekday at $time.
Welcome to planet $(hostname), "$title $USER!"
${messages[$(date +%w)]}

EOF`

echo $VAR1|cowsay

