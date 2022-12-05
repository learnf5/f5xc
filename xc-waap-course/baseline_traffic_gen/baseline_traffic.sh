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
SRC_ADDR1=$(ipconfig getifaddr en0)
SRC_ADDR2=$(ipconfig getifaddr en0)
SRC_ADDR3=$(ipconfig getifaddr en0)
#
###################################
#IP=$1
#IP="10.10.${student_id}.100"
#if [ "$IP" == "" ]
# then
#        #echo -n "Enter Target IP as an Argument"
#        #exit
#fi

BASELINE='Please enter your type of baselining: '
options=("increasing" "alternate" "Quit")
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
                                                curl -0 --interface $SRC_ADDR2 -s -o /dev/null -A "`shuf -n 1 useragents_with_bots.txt`"  https://$IP`shuf -n 1 urls.txt`
                                                curl -0 --interface $SRC_ADDR3 -s -o /dev/null -A "`shuf -n 1 useragents_with_bots.txt`"  https://$IP`shuf -n 1 urls.txt`
                                                #curl -0 -s -o /dev/null -A "`sort -R useragents_with_bots.txt | head -1`" -w "status: %{http_code}\tbytes: %{size_download}\ttime: %{time_total}\n" http://$IP`sort -R urls.txt | head -1`
                                        done
                                #sleep 0.1
                        done
                ;;
                "alternate")
                        while true; do
                                clear
                                echo "Hourly alternate traffic: $IP"
                                echo
                                #if (( {`date +%k` % 2} )); then
                                if (( `date +%k` % 2 )); then
                                        for i in {1..100};
                                                do
                                                        curl -0 --interface $SRC_ADDR1 -A -s -o /dev/null -A "`shuf -n 1 useragents_with_bots.txt`" -w "High:\tstatus: %{http_code}\tbytes: %{size_download}\ttime: %{time_total}\n" https://$IP`shuf -n 1 urls.txt`
                                                        curl -0 --interface $SRC_ADDR2 -A -s -o /dev/null -A "`shuf -n 1 useragents_with_bots.txt`" https://$IP`shuf -n 1 urls.txt`
                                                        curl -0 --interface $SRC_ADDR3 -A -s -o /dev/null -A "`shuf -n 1 useragents_with_bots.txt`" https://$IP`shuf -n 1 urls.txt`
                                                        #curl -0 -s -o /dev/null -A "`sort -R useragents_with_bots.txt | head -1`" -w "status: %{http_code}\tbytes: %{size_download}\ttime: %{time_total}\n" http://$IP`sort -R urls.txt | head -1`
                                                done
                                else
                                        for i in {1..50};
                                                do
                                                        curl --interface $SRC_ADDR1 -s -o /dev/null -A "`shuf -n 1 useragents_with_bots.txt`" -w "High:\tstatus: %{http_code}\tbytes: %{size_download}\ttime: %{time_total}\n" https://$IP`shuf -n 1 urls.txt`
                                                        curl --interface $SRC_ADDR2 -s -o /dev/null -A "`shuf -n 1 useragents_with_bots.txt`"  https://$IP`shuf -n 1 urls.txt`
                                                        curl --interface $SRC_ADDR3 -s -o /dev/null -A "`shuf -n 1 useragents_with_bots.txt`"  https://$IP`shuf -n 1 urls.txt`
                                                        #curl -0 -s -o /dev/null -A "`sort -R useragents_with_bots.txt | head -1`" -w "status: %{http_code}\tbytes: %{size_download}\ttime: %{time_total}\n" http://$IP`sort -R urls.txt | head -1`
                                                done
                                fi
                                #sleep 0.1
                                clear
                        done
                ;;
                "Quit")
                        break
                ;;
        *) echo invalid option;;
    esac
done

