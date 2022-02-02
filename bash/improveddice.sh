#!/bin/bash
#
# this script rolls a pair of six-sided dice and displays both the rolls
#

# Task 1:
#  put the number of sides in a variable which is used as the range for the random number
#  put the bias, or minimum value for the generated number in another variable
#  roll the dice using the variables for the range and bias i.e. RANDOM % range + bias
echo "Rolling..."
range="6"
bias="1"
die3=$(( RANDOM % $range + $bias))
die4=$(( RANDOM % $range + $bias))
echo "Rolled $die3, $die4"


# Task 2:
#  generate the sum of the dice
echo "SUM $((die3+die4))"
#  generate the average of the dice
avg=$(echo "($die3 + $die4) / 2" | bc -l)
printf "Average %.2f\n" $avg



#  display a summary of what was rolled, and what the results of your arithmetic were

# Tell the user we have started processing
echo ""
echo "Rolling..."

# roll the dice and save the results
die1=$(( RANDOM % 6 + 1))
die2=$(( RANDOM % 6 + 1 ))
# display the results
echo "Rolled $die1, $die2"

