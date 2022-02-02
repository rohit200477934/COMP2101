#!/bin/bash
#
# This script is for the bash lab on variables, dynamic data, and user input
# Download the script, do the tasks described in the comments
# Test your script, run it on the production server, screenshot that
# Send your script to your github repo, and submit the URL with screenshot on Blackboard

# Get the current hostname using the hostname command and save it in a variable
hs=`hostname`




# Tell the user what the current hostname is in a human friendly way
echo "current hostname $hs"

# Ask for the user's student number using the read command
echo 'Enter the student number:'
read studentnumber

# Use that to save the desired hostname of pcNNNNNNNNNN in a variable, where NNNNNNNNN is the student number entered by the user
STUDENTHOSTNAME=pc${studentnumber}

# If that hostname is not already in the /etc/hosts file, change the old hostname in that file to the new name using sed or something similar and
#     tell the user you did that
#e.g. sed -i "s/$oldname/$newname/" /etc/hosts
IP="127.0.1.1"
HOSTS_LINE="$IP\t$STUDENTHOSTNAME"
ETC_HOSTS="/etc/hosts"

if (( $(grep -c $IP $ETC_HOSTS) > 0 ));
        then
            if (( $(grep -c $STUDENTHOSTNAME $ETC_HOSTS) > 0 ));
                then
                    echo "$STUDENTHOSTNAME already exists : $(grep $STUDENTHOSTNAME  $ETC_HOSTS)";
                else
                    oldname=$(grep $IP /etc/hosts| awk  '{print $2}')
                    sudo -- sh -c -e "sed 's/$oldname/$STUDENTHOSTNAME/' $ETC_HOSTS > temp.txt";
                    sudo mv temp.txt $ETC_HOSTS;
                    if (( $(grep -c $STUDENTHOSTNAME $ETC_HOSTS) > 0 ));
                        then
                            echo "$STUDENTHOSTNAME is replaced $oldname in $ETC_HOSTS";
                        else
                            echo "Failed to Add $STUDENTHOSTNAME, Try again!";
                    fi

            fi
        else
            echo "Adding $STUDENTHOSTNAME to your $ETC_HOSTS";
            sudo -- sh -c -e "echo '$HOSTS_LINE' >> /etc/hosts";
            if (( $(grep -c $STUDENTHOSTNAME $ETC_HOSTS) > 0 ));
                then
                    echo "$STUDENTHOSTNAME was added succesfully ";
                else
                    echo "Failed to Add $STUDENTHOSTNAME, Try again!";
            fi

fi

# If that hostname is not the current hostname, change it using the hostnamectl command and
#     tell the user you changed the current hostname and they should reboot to make sure the new name takes full effect
#e.g. hostnamectl set-hostname $newname

if [ "$(hostname)" = "$STUDENTHOSTNAME" ];
    then
        echo "working";
    else



        hostnamectl set-hostname $STUDENTHOSTNAME ;
        if [ "$(hostname)" = "$STUDENTHOSTNAME" ];
            then
                echo "hostname is changed use 'systemctl reboot' to make sure the new name takes full effect";
            else
                echo "Failed to Add hostname $STUDENTHOSTNAME, Try again!";
        fi

fi

