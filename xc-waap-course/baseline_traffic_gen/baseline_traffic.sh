#!/bin/bash

# Created on Jul 12, 2022 12:30:39 PM

# v1.0 by sVen Mueller
# v1.1 modified for XC WAAP class P.K 10/9/2022
## This script creates dynamic basline traffic. It must be run for
## approximately 5-10 minutes prior to starting juice_BaDoS_DoS.sh.
#
# If you want to debug, change the first line to #!/bin/bash -x
# to get the student_id number from SSH_CLIENT env variable
trap ctrl_c INT

function ctrl_c() {
   echo "** Trapped CTRL-C"
   kill -9 $SYN1_PID
   exit 1
}
clear
echo "Traffic Baselining"
echo
####################################
#
# $1    IP address
IP=$1
#
# $2 Source Address 1
# $3 Source Address 2
# $4 Source Address 3
SRC_ADDR1=$(ip a show dev eth1 | grep inet |grep -v inet6| awk -F'[/ ]+' '{print $3}')
#

BASELINE='Please enter your type of baselining: '
options=("increasing" "Quit")
select opt in "${options[@]}"
do
        case $opt in
                "increasing")
                        while true; do
                                clear
                                echo "Hourly increasing traffic: $IP"
                                echo
                                for i in $(eval echo "{0..`date +%M`}")
                                        do
                                                curl -0 --interface $SRC_ADDR1 -s -o /dev/null -A "`shuf -n 1 useragents_with_bots.txt`" -w "status: %{http_code}\tbytes: %{size_download}\ttime: %{time_total}\n" https://$IP`shuf -n 1 urls.txt`   
                                                done
                                sleep 1
                        done
                ;;
                "Quit")
                        break
                ;;
        *) echo invalid option;;
    esac
done

