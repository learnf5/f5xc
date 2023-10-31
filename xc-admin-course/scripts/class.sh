#!/bin/bash

### set -e

### variables

product_name="F5 Distributed Cloud"
script_ver="1.0"
script_name="class.sh"

### Need to assign admin role to all namespaces to get perms to do anything here

v_token="9F9igLid8gdh9ZJZNJAlLUOaxSs="
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
echo "-tok                       Test token"
echo "-lan                       List all namespaces"
echo "-lsn                       List student namespaces"
echo "-lss <studentname>         List student sites"
echo "-lvs <studentname>         List student virtual sites (vpc)"
echo "-las <studentname>         List a student(s) details"
echo "-dss <studentname>         Disable student account"
echo "-ess <studentname>         Enable student account"
echo "-dis                       Disable all student accounts (20 secs per student)"
echo "-ena                       Enable all student accounts (ditto)"
echo "-del <studentname>         Delete student objects"
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

f_list_student_sites()
{
### curl -v -s -H "Authorization: APIToken $v_token" -X GET $v_url/config/namespaces/student11/sites
curl -s -H "Authorization: APIToken $v_token" -X GET $v_url/config/namespaces/${student_name}/sites | jq -r .[][].name |grep -E 'student[1-9]{1}'
}

f_list_student_vpc_sites()
{
### curl -v -s -H "Authorization: APIToken $v_token" -X GET $v_url/config/namespaces/shared/virtual_sites
curl -s -H "Authorization: APIToken $v_token" -X GET $v_url/config/namespaces/${student_name}/virtual_sites | jq -r .[][].name |grep -E 'student[1-9]{1}'
}

f_list_student()
{
curl -s -H "Authorization: APIToken $v_token" -X GET $v_url/web/custom/namespaces/${student_name}/whoami | jq
}

f_disable_student()
{
student_name=${student_name}@f5.com
curl -s -H "Authorization: APIToken $v_token" -H "Content-Type: application/json;"  -X PUT $v_url/web/namespaces/system/user/settings/idm/disable -d '{"user_email":"'${student_name}'"}'
}

f_enable_student()
{
student_name=${student_name}@f5.com
curl -s -H "Authorization: APIToken $v_token" -H "Content-Type: application/json;"  -X PUT $v_url/web/namespaces/system/user/settings/idm/enable -d '{"user_email":"'${student_name}'"}'
}

f_enadis_student()
{
### assumes each student has e-mail of studentX@f5.com
action=$1
for i in {1..12}
do
 student_name=student$i@f5.com
 echo "$action student$i"
 curl -s -H "Authorization: APIToken $v_token" -H "Content-Type: application/json;"  -X PUT $v_url/web/namespaces/system/user/settings/idm/$action -d '{"user_email":"'${student_name}'"}'
 sleep 5
done
}

f_delete_student_objects()
{
### This follows a strict sequence
### read keys
curl -v -s -H "Authorization: APIToken $v_token" -X GET "$api_url/config/namespaces/shared/known_labels_keys?key=&namespace=shared&query=QUERY_ALL_LABELS"
exit 1
curl -s -H "Authorization: APIToken $v_token" -X GET "$api_url/config/namespaces/shared/known_labels?key=&namespace=shared&query=QUERY_ALL_LABELS&value=" | jq -r .label[].value |grep -E 'student[1-9]{1}'
exit 1
s_label=${student_name}-key
s_key=${student_name}-key
echo "Delete key $s_key..."
curl -s -H "Authorization: APIToken $v_token" -X POST $v_url/config/namespaces/shared/known_label/delete -d '{"namespace":"shared","value":"$s_label","key":"$s_key"}'
exit 1
echo "Delete label ..."
echo "Delete virtual site ..."
echo "Delete vpc ..."
echo "Delete any other objects ..."
echo "Delete namespace ..."
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
   -lss)
   f_echo "List student sites ..."
   f_list_student_vpc_sites
   ;;
   -lvs)
   f_echo "List student vpc sites ..."
   f_list_student_sites
   ;;
   -las)
   f_echo "${student_name} details ..."
   f_list_student
   ;;
   -dss)
   f_echo "Disabling ${student_name} ..."
   f_disable_student
   sleep 5
   ;;
   -ess)
   f_echo "Enabling ${student_name} ..."
   f_enable_student
   sleep 5
   ;;
   -ena)
   f_echo "Enabling All students..."
   f_enadis_student enable
   ;;
   -dis)
   f_echo "Disabling All students..."
   f_enadis_student disable
   ;;
   -del)
   f_echo "Deleting ${student_name} objects ..."
   f_delete_student_objects
   ;;
   *)
   ### f_usage
   ;;
 esac
 shift
done
f_echo "End ..."