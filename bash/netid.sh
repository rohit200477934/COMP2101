#!/bin/bash
#
# this script displays some host identification information for a Linux machine
#
# Sample output:
#   Hostname      : zubu
#   LAN Address   : 192.168.2.2
#   LAN Name      : net2-linux
#   External IP   : 1.2.3.4
#   External Name : some.name.from.our.isp

# the LAN info in this script uses a hardcoded interface name of "eno1"
#    - change eno1 to whatever interface you have and want to gather info about in order to test the script

# TASK 1: Accept options on the command line for verbose mode and an interface name - must use the while loop and case command as shown in the lesson - getopts not acceptable for this task
#         If the user includes the option -v on the command line, set the variable $verbose to contain the string "yes"
#            e.g. network-config-expanded.sh -v
#         If the user includes one and only one string on the command line without any option letter in front of it, only show information for that interface
#            e.g. network-config-expanded.sh ens34
#         Your script must allow the user to specify both verbose mode and an interface name if they want
# TASK 2: Dynamically identify the list of interface names for the computer running the script, and  use a for loop to generate the report for every interface except loopback -
# do not include loopback network information in your output

verbose="no"
interface=""
while [ $# -gt 0 ]; do
    case "$1" in
        -v )
            verbose="yes"
            ;;
        * )
            if [[ $1 = -* ]]
            then
                echo "invalid arguments option"
                exit 2
            fi
            if [ "$interface" != "" ]; then
                echo "too many arguments"
                exit 2
            else
                interface=$1
            fi
            ;;
    esac
    shift
done

if [ "$interface" != "" ]; then

[ "$verbose" = "yes" ] && echo "Reporting on interface(s): $interface"
[ "$verbose" = "yes" ] && echo "Getting IPV4 address and name for interface $interface"
[ "$verbose" = "yes" ] && echo "Getting IPV4 network block info and name for interface $interface"
ipv4_address=$(ip a s $interface|awk -F '[/ ]+' '/inet /{print $3}')
ipv4_hostname=$(getent hosts $ipv4_address | awk '{print $2}')

network_address=$(ip route list dev $interface scope link|cut -d ' ' -f 1)
network_number=$(cut -d / -f 1 <<<"$network_address")
network_name=$(getent networks $network_number|awk '{print $1}')

cat <<EOF

Interface $interface:
===============
Address         : $ipv4_address
Name            : $ipv4_hostname
Network Address : $network_address
Network Name    : $network_name

EOF
#####
# End of per-interface report
#####

else
[ "$verbose" = "yes" ] && echo "Gathering host information"
my_hostname="$(hostname) / $(hostname -I)"

[ "$verbose" = "yes" ] && echo "Identifying default route"
default_router_address=$(ip r s default| awk '{print $3}')
default_router_name=$(getent hosts $default_router_address|awk '{print $2}')

[ "$verbose" = "yes" ] && echo "Checking for external IP address and hostname"
external_address=$(curl -s icanhazip.com)
external_name=$(getent hosts $external_address | awk '{print $2}')

cat <<EOF

System Identification Summary
=============================
Hostname      : $my_hostname
Default Router: $default_router_address
Router Name   : $default_router_name
External IP   : $external_address
External Name : $external_name

EOF
for interface in $(ifconfig | cut -d ' ' -f1| tr ':' '\n' | awk NF)
do

[ "$verbose" = "yes" ] && echo "Reporting on interface(s): $interface"
[ "$verbose" = "yes" ] && echo "Getting IPV4 address and name for interface $interface"
[ "$verbose" = "yes" ] && echo "Getting IPV4 network block info and name for interface $interface"
ipv4_address=$(ip a s $interface|awk -F '[/ ]+' '/inet /{print $3}')
ipv4_hostname=$(getent hosts $ipv4_address | awk '{print $2}')

network_address=$(ip route list dev $interface scope link|cut -d ' ' -f 1)
network_number=$(cut -d / -f 1 <<<"$network_address")
network_name=$(getent networks $network_number|awk '{print $1}')
cat <<EOF

Interface $interface:
===============
Address         : $ipv4_address
Name            : $ipv4_hostname
Network Address : $network_address
Network Name    : $network_name

EOF
done
fi



