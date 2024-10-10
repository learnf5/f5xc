#!/bin/bash

### variables

product_name="F5 Distributed Cloud"
script_ver="1.0"
script_name="mc.sh"
student_name=$2

v_token="CfxhI08CzaktknCrXwsrCmOPibI="
v_url="https://training-dev.console.ves.volterra.io/api"
v_tenant="training-dev-fcphvhww"
v_dom="dev.learnf5.cloud"
v_aws_creds_name="learnf5-aws"
v_azu_creds_name="all-students-credentials"

### functions

f_echo()
{
echo -e $1
}

f_usage()
{
echo "Class setup script for Multi Cloud"
echo ""
echo "Usage: ./${script_name} -option"
echo ""
echo "Options:"
echo ""
echo "-tok                       Test token"
echo "-mccs                      Check sites status"
echo ""
exit 0
}

f_test_token()
{
curl -s -X GET -H "Authorization: APIToken $v_token" $v_url/web/namespaces | jq
}

f_mc_check_sites_status()
{
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/web/namespaces" -d '{"metadata":{"name":"'$1'"},"spec":{}}' | jq
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
   -mccs)
   f_echo "Checking cloud site status ..."
   f_mc_check_sites_status
   ;;
   *)
   ;;
 esac
 shift
done
f_echo "End ..."
