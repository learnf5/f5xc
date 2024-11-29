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
echo "-tok                       Test token"
echo "-adcheck <sitename>        ADMIN Check if logs exist for sitename"
echo "-adstart <sitename>        ADMIN Start log collection on site"
echo "-adlogs <sitename>         ADMIN Get logs for sitename"
echo ""
echo "See https://docs.cloud.f5.com/docs-v2/api/operate-debug"
echo ""
echo "Unfortunately the APIs mix sitename and node and are not clear what they refer to"
echo ""
echo "sitename is the name of the F5XC vpc object, studentX-vpc for example"
echo "nodename is NOT the CE cluster kubernetes nodename, its the XC nodename, found inside"
echo "Multi-Cloud Network Connect > Overview > Infrastructure > Sites > student3-vpc > Metrics > Nodes"
echo "For student3 that name is ip-172-31-3-5"
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
s_sitename="$1-vpc"
s_nodename="ip-172-31-3-54"
curl -s -H "Content-Type:application/json" -H "Authorization: APIToken $v_token" -X GET "$v_url/operate/namespaces/system/sites/$s_sitename/vpm/debug/$s_nodename/start-debug-info-collection" | jq
}

f_admin_get_logs()
{
s_cename="$1-vpc"
s_nodename="ip-172-31-3-54"
curl -s -H "Content-Type:application/json" -H "Authorization: APIToken $v_token" -X GET "$v_url/operate/namespaces/system/sites/$s_cename/vpm/debug/$s_nodename/vpm/log" | jq
}

### main

f_echo "F5 Training $product_name script Version $script_ver"

if [ $# -eq 0 ]; then
f_usage
fi

while [ $# -gt 0 ]; do
 case "$1" in
   -adcheck)
   if [ "$#" != 2 ]; then
    f_echo "Missing student name ... "
    exit 1
   fi
   f_echo "Checking CE logs for $2 ..."
   f_admin_check_logs $2
   ;;
   -adstart)
   if [ "$#" != 2 ]; then
    f_echo "Missing student name ... "
    exit 1
   fi
   f_echo "Starting log collection for $2 ..."
   f_admin_start_logs $2
   ;;
   -adlogs)
   if [ "$#" != 2 ]; then
    f_echo "Missing student name ... "
    exit 1
   fi
   f_echo "Getting CE logs for $2 ..."
   f_admin_get_logs $2
   ;;
   *)
   ;;
 esac
 shift
done
f_echo "End ..."
