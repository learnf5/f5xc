#!/bin/bash

### variables

product_name="F5 Distributed Cloud"
script_ver="3.0"
script_name="class1.sh"
student_name=$2

v_token="vF/f4ztMX/HI9/quX9cWMM6SH18="
v_url="https://training1.console.ves.volterra.io/api"
v_tenant="training1-rcfjmagj"
v_dom="f5training1.cloud"
v_aws_creds_name="creds-aws1211gst01"
v_logfile="$script_name.log"

### functions

f_log()
{
 echo $1 >>$v_logfile
 date >>$v_logfile
}

f_dots()
{
echo "Sleeping for $1 ..."
i=1
while [ "$i" -le "$1" ]; do
 echo -n "*"
 sleep 1
 i=$(($i + 1))
done
}

f_echo()
{
echo -e $1
}

f_usage()
{
echo "Classroom 1 setup script for Admin and WAAP"
echo ""
echo "Student numbers run from 101 to 112"
echo ""
echo "Usage: ./${script_name} -option"
echo ""
echo "Options:"
echo ""
echo "-tok                       Test token"
echo ""
echo "-a1 <password>             ADMIN - Encrypt AWS Keys - requires awskeys file"
echo "-a2 <password>             ADMIN - Decrypt AWS Keys"
echo ""
echo "-w1                        WAAP - Do something"
echo ""
echo ""
echo "Prerequisites:"
echo ""
echo "1 - The API token must work, they expire, run the -tok option to check still valid"
echo "2 - The awskeys file must exist in the current directory"
echo ""
echo "Notes:"
echo ""
exit 0
}

f_test_token()
{
curl -s -X GET -H "Authorization: APIToken $v_token" $v_url/web/namespaces | jq
}

f_a1()
{
echo $1
openssl enc -aes-256-cbc -salt -a -pbkdf2 -in awskeys -out awskeys.enc -pass pass:$1
}

f_a2()
{
awsk1=""
awsk2=""
awsk3=""
openssl enc -aes-256-cbc -salt -a -pbkdf2 -in awskeys.enc -d -pass pass:$1 -out awskeys.dcr
declare -a args=()
while read line
do
 args+=( "$line" )
done < awskeys.dcr
echo "Key1 is: ${args[0]}"
echo "Key2 is: ${args[1]}"
echo "Key3 is: ${args[2]}"
awsk1=${args[0]}
awsk2=${args[1]}
awsk3=${args[2]}
}

### main

f_echo "F5 Training $product_name script Version $script_ver"

if [ $# -eq 0 ]; then
f_usage
fi

f_log start
while [ $# -gt 0 ]; do
 case "$1" in
   -tok)
   f_test_token
   ;;
   -a1)
   if [ "$#" != 2 ]; then
    f_echo "Missing password ... "
   exit 1
   fi
   f_echo "Encrypt AWS keys ..."
   f_a1
   ;;
   -a2)
   if [ "$#" != 2 ]; then
    f_echo "Missing password ... "
   exit 1
   fi
   f_echo "Decrypt AWS keys ..."
   f_a2
   ;;
   *)
   ;;
 esac
 shift
done
f_log finish
f_echo "End ..."
