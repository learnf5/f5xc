#!/bin/bash

### variables

product_name="F5 Distributed Cloud"
script_ver="1.0"
script_name="logs.sh"

### Points to the Training Development F5XC console which points to the Internal Training AWS instance
### v_token="CfxhI08CzaktknCrXwsrCmOPibI="
### v_url="https://training-dev.console.ves.volterra.io/api"
### v_tenant="training-dev-fcphvhww"
### v_dom="dev.learnf5.cloud"
### v_aws_creds_name="learnf5-aws"

### Points to classroom 1 - the First Public Training F5XC console which points to the Training AWS instance
v_token="TREqu7Yp55Pfvon+MmLXpavWV7uAYXw="
v_url="https://training.console.ves.volterra.io/api"
v_tenant="training-ytfhxsmw"

### functions

f_echo()
{
echo -e $1
}

f_usage()
{
echo "Check for all things logs"
echo ""
echo "Usage: ./${script_name} -option"
echo ""
echo "Options:"
echo ""
echo "-tok                                   Test token"
echo "-adcheck <studentname>                 ADMIN Check if logs exist for sitename"
echo "-adstart <studentname> <nodename>      ADMIN Start log collection on site"
echo "-adlog <studentname> <nodename>        ADMIN Get (a) log for sitename"
echo "-adzip <studentname>                   ** does not work ** ADMIN Get the zip file of all logs for sitename"
echo "-adsrv <studentname>                   ADMIN List services"
echo ""
echo "See https://docs.cloud.f5.com/docs-v2/api/operate-debug"
echo ""
echo "sitename is the name of the F5XC vpc object, studentX-vpc for example"
echo "nodename is NOT the CE cluster kubernetes nodename, its the XC nodename, found inside"
echo "Multi-Cloud Network Connect > Overview > Infrastructure > Sites > student3-vpc > Metrics > Nodes"
echo "For student3 that name is ip-172-31-3-5 which is a form of the private IPv4 AWS address"
echo ""
echo "Logs have to be first started, then collected. Old logs won't be collected after an hour"
echo ""
echo "Nodename IP address is random so have to read GUI each time a VPC is created"
echo ""
exit 0
}

f_test_token()
{
curl -s -X GET -H "Authorization: APIToken $v_token" $v_url/web/namespaces | jq
}

f_admin_check_logs()
{
s_sitename="$1-vpc"
curl -s -H "Content-Type:application/json" -H "Authorization: APIToken $v_token" -X GET "$v_url/operate/namespaces/system/sites/$s_sitename/vpm/debug/global/check-debug-info-collection?site=$s_sitename" | jq
}

f_admin_start_logs()
{
s_sitename="$2-vpc"
### s_nodename="ip-172-31-3-54"
s_nodename="$1"
curl -s -H "Content-Type:application/json" -H "Authorization: APIToken $v_token" -X GET "$v_url/operate/namespaces/system/sites/$s_sitename/vpm/debug/$s_nodename/start-debug-info-collection" | jq
}

f_admin_get_log()
{
s_sitename="$2-vpc"
### s_nodename="ip-172-31-3-54"
s_nodename="$1"
curl -s -H "Content-Type:application/json" -H "Authorization: APIToken $v_token" -X GET "$v_url/operate/namespaces/system/sites/$s_sitename/vpm/debug/$s_nodename/vpm/log" | jq
}

f_admin_get_zip()
{
s_sitename="$1-vpc"
curl -s -H "Content-Type:application/json" -H "Authorization: APIToken $v_token" -X GET "$v_url/operate/namespaces/system/sites/$s_sitename/vpm/debug/global/download-debug-info-collection"
}

f_admin_list_services()
{
s_sitename="$1-vpc"
curl -s -H "Content-Type:application/json" -H "Authorization: APIToken $v_token" -X GET "$v_url/operate/namespaces/$1/sites/$s_sitename/vpm/debug/global/list-service"
}

### main

f_echo "F5 Training $product_name script Version $script_ver"

if [ $# -eq 0 ]; then
f_usage
fi

while [ $# -gt 0 ]; do
 case "$1" in
   -tok)
   f_test_token
   ;;
   -adcheck)
   if [ "$#" != 2 ]; then
    f_echo "Missing student name ... "
    exit 1
   fi
   f_echo "Checking CE logs for $2 ..."
   f_admin_check_logs $2
   ;;
   -adstart)
   if [ "$#" != 3 ]; then
    f_echo "Missing nodename or student name ... "
    exit 1
   fi
   f_echo "Starting CE log collection for $3 ..."
   f_admin_start_logs $2 $3
   ;;
   -adlog)
   if [ "$#" != 3 ]; then
    f_echo "Missing nodename or student name ... "
    exit 1
   fi
   f_echo "Getting CE log for $3 ..."
   f_admin_get_log $2 $3
   ;;
   -adzip)
   if [ "$#" != 2 ]; then
    f_echo "Missing student name ... "
    exit 1
   fi
   f_echo "Getting zip file of logs for $2 ..."
   f_admin_get_zip $2
   ;;
   -adsrv)
   if [ "$#" != 2 ]; then
    f_echo "Missing student name ... "
    exit 1
   fi
   f_echo "List services for $2 ..."
   f_admin_list_services $2
   ;;
   *)
   ;;
 esac
 shift
done
f_echo "End ..."
