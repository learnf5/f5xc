#!/bin/bash

### set -e

### variables

product_name="F5 Distributed Cloud"
script_ver="1.0"
script_name="class.sh"

v_token="VnumhqWp10BhlzRF1mryB1u0M6g="
v_url="https://training.console.ves.volterra.io/api"

student_name=$2

### functions

f_echo()
{
echo -e $1
}

f_usage()
{
echo ""
echo "Usage: ./${script_name} -option"
echo ""
echo "Options:"
echo ""
echo "-tok                    Test token"
echo "-lan                    List all namespaces"
echo "-lsn                    List student namespaces"
echo "-las <studentname>      List a student(s) details"
echo "-dss <studentname>      Disable student account"
echo "-ess <studentname>      Enable student account"
echo ""
echo "Prerequisites:"
echo ""
echo "1 - The API token must work, they expire, run the -tok option to check still valid"
echo "1 - See https://docs.cloud.f5.com/docs/how-to/user-mgmt/credentials on how to generate a token"
echo ""
echo "Notes:"
echo ""
echo ""
exit 0
}

f_test_token()
{
curl -s -X GET -H "Authorization: APIToken $v_token" $v_url/web/namespaces | jq
}

f_list_all_namespaces()
{
ns_list="$(curl -s -X GET -H "Authorization: APIToken $v_token" $v_url/web/namespaces | jq -r .[][].name)"
echo "All Namespaces:"
echo $ns_list
}

f_list_student_namespaces()
{
ns_list="$(curl -s -X GET -H "Authorization: APIToken $v_token" $v_url/web/namespaces | jq -r .[][].name |grep -E 'student[1-9]{1}')"
echo "Student Namespaces:"
echo $ns_list
}

f_list_sites()
{
site_list="$(curl -s -X GET -H "Authorization: APIToken $v_token" $v_url/config/namespaces/system/sites | jq -r .[][].name |grep -E 'student[1-9]{1}')"
echo "Sites:"
echo $site_list
}

f_list_student()
{
curl -s -X GET -H "Authorization: APIToken $v_token" $v_url/web/custom/namespaces/${student_name}/whoami | jq
}

f_disable_student()
{
curl -s -X GET -H "Authorization: APIToken $v_token" $v_url/web/custom/namespaces/${student_name}/whoami | jq
}

f_enable_student()
{
curl -s -X GET -H "Authorization: APIToken $v_token" $v_url/web/custom/namespaces/${student_name}/whoami | jq
}

### main

f_echo "F5 Training $product_name script Ver $script_ver"

if [ $# -eq 0 ]; then
f_usage
fi

while [ $# -gt 0 ]; do
 case "$1" in
   -tok)
   f_test_token
   ;;
   -lan)
   f_echo "List all namespaces ..."
   f_list_all_namespaces
   ;;
   -lsn)
   f_echo "List student namespaces ..."
   f_list_student_namespaces
   ;;
   -las)
   f_echo "${student_name} details ..."
   f_list_student
   ;;
   -dss)
   f_echo "Disabling ${student_name} ..."
   f_disable_student
   ;;
   -ess)
   f_echo "Enabling ${student_name} ..."
   f_enable_student
   ;;
   *)
   ### f_usage
   ;;
 esac
 shift
done
f_echo "End ..."