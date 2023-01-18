#!/bin/bash

# Created on Jul 12, 2022 12:30:39 PM

# v1.0 by sVen Mueller
# v1.1 Modified for XC WAAP class P.K 9/9/2022 
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
IP=$1

# Platform Check
platform=$(uname)
if [[ $platform == 'Linux' ]]; then
        echo "Your platform is Linux"
        SRC_ADDR1=$(ip a show dev eth1 | grep inet |grep -v inet6| awk -F'[/ ]+' '{print $3}')
elif [[ $platform == 'Darwin' ]]; then
        echo "Your platform is Mac"
        SRC_ADDR1=$(ifconfig en0 | grep inet | grep -v inet6 |awk '{print $2}')
        echo $SRC_ADDR1
fi

BASELINE='Please enter your type of baselining: '
options=("Send malicious traffic" "Quit")

select opt in "${options[@]}"
do
        case $opt in
                "Send malicious traffic")
                        while true; do
                                clear
                                echo "Hourly increasing traffic: $IP"
                                echo
                                for i in $(eval echo "{0..`date +%M`}")
                                        do
                                                curl -0 --interface $SRC_ADDR1 -A "`shuf -n 1 useragents_with_bots.txt`" -w "status: %{http_code}\tbytes: %{size_download}\ttime: %{time_total}\n" https://$IP`shuf -n 1 urls.txt`
                                                
                                        done                      
                        done
                ;;
        *) echo invalid option;;
    esac
done

