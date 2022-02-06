#!/bin/bash
#
# This script implements a guessing game
# it will pick a secret number from 1 to 10
# it will then repeatedly ask the user to guess the number
#    until the user gets it right

# Give the user instructions for the game
cat <<EOF
Let's play a game.
I will pick a secret number from 1 to 10 and you have to guess it.
If you get it right, you get a virtual prize.
Here we go!

EOF

# Pick the secret number and save it
secretnumber=$(($RANDOM % 10 +1)) # save our secret number to compare later

# This loop repeatedly asks the user to guess and tells them if they got the right answer
# TASK 1: Test the user input to make sure it is not blank
# TASK 2: Test the user input to make sure it is a number from 1 to 10 inclusive
# TASK 3: Tell the user if their guess is too low, or too high after each incorrect guess

echo "Give me a number from 1 to 10:"
while read userguess
do
    if [ -z "$userguess" ];
	then
	    echo "It is blank give me a number from 1 to 10:"
	elif ! ((userguess >= 1 && userguess <= 10));
	then
	    echo "Please guess from 1 to 10:"
	elif [ $userguess != $secretnumber ];
	then
	    if ((userguess < secretnumber ));
	    then
	        echo "your guess is low"
	    fi
	    if ((userguess > secretnumber ));
	    then
	        echo "your guess is high"
	    fi
	    echo "Give me a number from 1 to 10:"
	else
	    break
	fi
done
echo "You got it! Have a milkdud."


