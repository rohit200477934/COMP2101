#!/bin/bash
#
# this script demonstrates doing arithmetic

# Task 1: Remove the assignments of numbers to the first and second number variables. Use one or more read commands to get 3 numbers from the user.
# Task 2: Change the output to only show:
#    the sum of the 3 numbers with a label
#    the product of the 3 numbers with a label

echo "Enter first number"
read firstnum
echo "Enter second number"
read secondnum
echo "Enter third number"
read thirdnum


sum=$((firstnum + secondnum + thirdnum))
multiple=$((firstnum * secondnum * thirdnum))


cat <<EOF
sum is $sum
product is $multiple
EOF

