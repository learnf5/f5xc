#!/bin/bash

### variables

product_name="F5 Distributed Cloud"
script_ver="1.0"
script_name="logs.sh"

### Points to classroom 1 - the First Public Training F5XC console
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
echo "-site <studentname>                    Find the nodename per sitename"
echo "-adcheck <studentname>                 ADMIN Check if logs exist for sitename"
echo "-adstart <nodename> <studentname>      ADMIN Start log collection on site"
echo "-adlog <nodename> <studentname>        ADMIN Get (a) log for sitename"
echo "-adzip <studentname>                   ** does not work ** ADMIN Get the zip file of all logs for sitename"
echo "-adsrv <studentname>                   ADMIN List services"
echo "-adsta <nodename> <studentname>        ADMIN Get sitename status"
echo ""
echo "See https://docs.cloud.f5.com/docs-v2/api/operate-debug"
echo ""
echo "sitename is the name of the F5XC vpc object, studentX-vpc for example"
echo "nodename is NOT the CE cluster kubernetes nodename, its the XC nodename, found inside"
echo "Multi-Cloud Network Connect > Overview > Infrastructure > Sites > student3-vpc > Metrics > Nodes"
echo "For student3 that name is ip-172-31-3-5 which is a form of the private IPv4 AWS address"
echo "Nodename IP address is random so have to read the GUI each time a VPC is created"
echo ""
echo "Or ... run the -site option to list it and copy and paste into command line"
echo ""
echo "Logs have to be first started, then collected. Old logs won't be collected after an hour"
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
echo $2
echo $s_sitename
echo $1
echo $s_nodename
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

f_admin_get_status()
{
s_sitename="$2-vpc"
s_vesnamespace="$1"
### s_vesnamespace="ves-system"
### s_vesnamespace="ves-io-ce"
### s_vesnamespace="ves-vpc-auto-$1-vpc"
### Appears not implemented for next two variables. Ves namespace seems to be nodename
### s_vesnamespace="ves-io-AWS"
### s_vesnamespace="ip-172-31-3-54"
curl -s -H "Content-Type:application/json" -H "Authorization: APIToken $v_token" -X GET "$v_url/operate/namespaces/$1/sites/$s_sitename/vpm/debug/$s_vesnamespace/status"
}

f_site()
{
### echo "Listing all sites ..."
### curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/system/sites"
echo "Listing virtual site $1-vpc ..."
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/system/sites/$1-vpc"
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
   -adsta)
   if [ "$#" != 3 ]; then
    f_echo "Missing nodename or student name ... "
    exit 1
   fi
   f_echo "Get sitename status for $2 ..."
   f_admin_get_status $2 $3
   ;;
   -site)
   if [ "$#" != 2 ]; then
    f_echo "Missing student name ... "
    exit 1
   fi
   f_echo "Searching for the nodename for $2-vpc ..."
   f_site $2
   ;;
   *)
   ;;
 esac
 shift
done
f_echo "End ..."
