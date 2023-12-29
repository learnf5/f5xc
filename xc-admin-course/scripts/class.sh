#!/bin/bash

### set -e

### variables

product_name="F5 Distributed Cloud"
script_ver="1.0"
script_name="class.sh"

### Points to the Training Devopment F5XC console which points to the Internal Training AWS instance
v_token="CfxhI08CzaktknCrXwsrCmOPibI="
v_url="https://training-dev.console.ves.volterra.io/api"

### v_token="9F9igLid8gdh9ZJZNJAlLUOaxSs="
### v_url="https://training.console.ves.volterra.io/api"

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
echo "-lso                       List all student objects"
echo "-del                       Delete all student objects"
echo "-dso <studentname>         Delete single student objects"
echo "-wadso <studentname>       WAAP - Delete single student objects"
echo "-wadall                    WAAP - Delete all student objects"
echo "-wacre <studentname>       WAAP - Create first labs student objects"
echo ""
echo "Prerequisites:"
echo ""
echo "1 - The API token must work, they expire, run the -tok option to check still valid"
echo "  - See https://docs.cloud.f5.com/docs/how-to/user-mgmt/credentials or Xyleme notes"
echo "  - on how to generate a token"
echo "2 - Relies on students naming their namespace correctly"
echo ""
echo "Notes:"
echo ""
echo "Run the single options and starting options to see what's there, then go to delete all"
echo "API calls are sent, with timers after them, so the script takes its time deleting each entry"
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
 curl -s -H "Authorization: APIToken $v_token" -H "Content-Type: application/json;" -X PUT $v_url/web/namespaces/system/user/settings/idm/$action -d '{"user_email":"'${student_name}'"}'
 sleep 5
done
}

f_list_student_objects()
{
### List all objects before deletion and after to check
echo "Known keys ..."
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/shared/known_label_keys?key=&namespace=shared&query=QUERY_ALL_LABEL_KEYS" | jq -r .label_key[].key | grep -E 'student[1-9]{1}'
echo "Known labels ..."
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/shared/known_labels?key=&namespace=shared&query=QUERY_ALL_LABELS&value=" | jq -r .label[].value |grep -E 'student[1-9]{1}'
echo "Known sites ..."
### interesting the AWS vpc sites are in a namespace, a system one, not user namespaces
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/system/sites" | jq -r .[][].name |grep -E 'student[1-9]{1}'
echo "Known virtual sites ..."
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/shared/virtual_sites" | jq -r .[][].name | grep -E 'student[1-9]{1}'
### should not need to delete these, why do they exist even for this class
echo "Known API credentials ..."
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/web/namespaces/system/api_credentials" | jq -r .[][].name | grep -E 'student[1-9]{1}'
echo "Known Alert receivers ..."
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/system/alert_receivers" | jq -r .[][].name | grep -E 'student[1-9]{1}'
echo "Known Alert policies ..."
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/shared/alert_policys" | jq -r .[][].name | grep -E 'student[1-9]{1}'
echo "Known namespaces ..."
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/web/namespaces" | jq -r .[][].name |grep -E 'student[1-9]{1}'
echo "Known (Web) App firewalls ..."
ns_list="$(curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/web/namespaces" | jq -r .[][].name |grep -E 'student[1-9]{1}')"
### have to loop through all namespaces to get firewalls
for ns_name in ${ns_list[@]}; do
 curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/$ns_name/app_firewalls" | jq -r .[][].name | grep -E 'student[1-9]{1}'
done
echo "Known HTTP Load balancers ..."
ns_list="$(curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/web/namespaces" | jq -r .[][].name |grep -E 'student[1-9]{1}')"
for ns_name in ${ns_list[@]}; do
 curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/$ns_name/http_loadbalancers" | jq -r .[][].name | grep -E 'student[1-9]{1}'
done
echo "Known Routes ..."
ns_list="$(curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/web/namespaces" | jq -r .[][].name |grep -E 'student[1-9]{1}')"
for ns_name in ${ns_list[@]}; do
 curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/$ns_name/routes" | jq -r .[][].name | grep -E 'student[1-9]{1}'
done
echo "Known Service Policies ..."
ns_list="$(curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/web/namespaces" | jq -r .[][].name |grep -E 'student[1-9]{1}')"
for ns_name in ${ns_list[@]}; do
 curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/$ns_name/service_policys" | jq -r .[][].name | grep -E 'student[1-9]{1}'
done
echo "Known Malicious User Mitigations ..."
ns_list="$(curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/web/namespaces" | jq -r .[][].name |grep -E 'student[1-9]{1}')"
for ns_name in ${ns_list[@]}; do
 curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/$ns_name/malicious_user_mitigations" | jq -r .[][].name | grep -E 'student[1-9]{1}'
done
}

f_delete_single_student_objects()
{
### This follows a strict sequence working backwards in admin class
### In testing uncomment the GET calls to see the objects before delete
echo "Deleting (Web) App firewalls ..."
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/$1/app_firewalls" | jq -r .[][].name | grep -E $1
sleep 2
### curl -s -H "Authorization: APIToken $v_token" -X DELETE "$v_url/config/namespaces/$1/app_firewalls/$1-waf" | jq
sleep 2
### There are 4 types of receivers and policies, namespace and tenant levels
### The system path only sees the tenant level
### curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/system/alert_receivers" | jq -r .[][].name | grep -E $1
echo "Deleting Alert Receivers namespace level ..."
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/$1/alert_receivers" | jq -r .[][].name | grep -E $1
sleep 2
### curl -s -H "Authorization: APIToken $v_token" -X DELETE "$v_url/config/namespaces/$1/alert_receivers/$1-tenant-alert-receiver" | jq
sleep 2
### curl -s -H "Authorization: APIToken $v_token" -X DELETE "$v_url/config/namespaces/$1/alert_receivers/$1-ns-alert-receiver" | jq
sleep 2
### curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/shared/alert_policys" | jq -r .[][].name | grep -E $1
sleep 2
echo "Deleting Alert Policies namespace level..."
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/$1/alert_policys" | jq -r .[][].name | grep -E $1
sleep 2
### curl -s -H "Authorization: APIToken $v_token" -X DELETE "$v_url/config/namespaces/$1/alert_policys/$1-tenant-alert-policy" | jq
sleep 2
### curl -s -H "Authorization: APIToken $v_token" -X DELETE "$v_url/config/namespaces/$1/alert_policys/$1-ns-alert-policy" | jq
sleep 2
### Keys and labels are created in rhe shared namespace
echo "Deleting known labels ..."
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/shared/known_labels?key=&namespace=shared&query=QUERY_ALL_LABELS&value=" | jq -r .label[].value |grep -E $1
### curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/shared/known_label/delete" -d '{"namespace":"shared","value":"'$1'-value","key":"'$1'-key"}'
sleep 2
echo "Deleting known keys ..."
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/shared/known_label_keys?key=&namespace=shared&query=QUERY_ALL_LABEL_KEYS" | jq -r .label_key[].key | grep -E $1
sleep 2
### curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/shared/known_label_key/delete" -d '{"namespace":"shared","key":"'$1'-key"}'
sleep 2
### 3 types of sites systems sites virtual sites aws sites
echo "Deleting known virtual sites ..."
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/shared/virtual_sites" | jq -r .[][].name | grep -E $1
### Seems the same as alerts system sees nothing however about student sites
### curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/system/sites" | jq -r .[][].name | grep -E $1
sleep 2
### curl -s -H "Authorization: APIToken $v_token" -X DELETE "$v_url/config/namespaces/$1/virtual_sites/$1-vsite" | jq
sleep 2
echo "Deleting namespace ..."
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/web/namespaces" | jq -r .[][].name | grep -E $1
sleep 2
### curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/web/namespaces/$1/cascade_delete" | jq
sleep 2
echo "Deleting API credentials ..."
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/web/namespaces/system/api_credentials" | jq -r .[][].name | grep -E $1
sleep 2
}

f_waap_delete_single_student_objects()
{
### Only need to delete student namespace to delete all objects
### If only delete the HTTP load balancer it removs half of the objects as well
### EXCEPT when XC puts objects into shared space like App Firewalls sometimes and they are not deleted
echo "Deleting namespace ..."
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/web/namespaces" | jq -r .[][].name | grep -E $1
sleep 2
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/web/namespaces/$1/cascade_delete" | jq
echo "Run the -lso object again to check for object outliers and manually delete them ..."
}

f_waap_delete_all_student_objects()
{
for ((i=1; i<=12; i++))
do
 echo "Deleting student$i ..."
 ### It picks up both single and multiple numbers in the student name listing just ignore
 curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/web/namespaces" | jq -r .[][].name | grep -E student$i
 sleep 1
 curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/web/namespaces/student$i/cascade_delete" | jq
done
echo "Run the -lso object again to check for object outliers and manually delete them ..."
}

f_waap_create_single_student_objects()
{
### Create labs 1-3 for a student
echo "Listing existing objects for $1 ..."
### curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/web/namespaces" | jq -r .[][].name |grep -E $1
###curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/$1/http_loadbalancers?report_fields" | jq
###curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/$1/origin_pools" | jq
### curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/$1/healthchecks?report_fields" | jq
### curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/$1/origin_pools/$1-juice-originpool?report_fields" | jq
### curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/ml/data/namespaces/$1/http_loadbalancers/$1-juice-lb/api_endpoints" | jq
echo "Creating Namespace for $1 ..."
### curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/web/namespaces" -d '{"metadata":{"name":"'$1'"},"spec":{}}' | jq
sleep 1
### have to create OP, Origin server, health check beforehand and reference in load balancer
echo "Creating Health check for HTTP Load Balancer for $1 ..."
### curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$1/healthchecks" -d '{"metadata":{"name":"student4-hc"},"spec":{"healthy_threshold":3,"http_health_check":{"expected_status_codes":["200"],"path":"/"},"interval":15,"timeout":3,"jitter_percent":30,"unhealthy_threshold":1}}' | jq
sleep 1
echo "Creating Origin Pool and Origin Server for HTTP Load Balancer for $1 ..."
### curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$1/origin_pools" -d '{"metadata":{"name":"student4-juice-originpool"},"spec":{"gc_spec":{},"origin_servers":[{"public_ip":{"ip":"23.22.60.254"},"labels":{}}],"port":443,"healthcheck":[{"namespace":"student4","name":"student4-hc"}]}}' | jq
sleep 1
echo "Creating HTTP Load Balancer for $1 ..."
### curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$1/http_loadbalancers" -d '{ "metadata":{"name":"student4-juice-lb","namespace":"student4"},"spec":{"domains":["student4-juice.aws.learnf5.cloud"],"https_auto_cert":{"add_hsts":true,"http_redirect":true},"port":"443","default_route_pools":[{"pool":{"namespace":"student4","name":"student4-juice-originpool"},"weight":"1","priority":"1"}],"add_location":true,"enable_api_discovery":{"enable_learn_from_redirect_traffic":{},"discovered_api_settings":{"purge_duration_for_inactive_discovered_apis":2}}} }' | jq
}

f_delete_all_student_objects()
{
### This follows a strict sequence
echo "Deleting (Web) App firewalls ..."
### ns_list="$(curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/web/namespaces" | jq -r .[][].name |grep -E 'student[1-9]{1}')"
### for ns_name in ${ns_list[@]}; do
###  curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/$ns_name/app_firewalls" | jq -r .[][].name | grep -E 'student[1-9]{1}'
### done
echo "Exiting ..."
exit 0
### echo "Known keys ..."
### curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/shared/known_label_keys?key=&namespace=shared&query=QUERY_ALL_LABEL_KEYS" | jq -r .label_key[].key | grep -E 'student[1-9]{1}'
### echo "Known labels ..."
### curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/shared/known_labels?key=&namespace=shared&query=QUERY_ALL_LABELS&value=" | jq -r .label[].value |grep -E 'student[1-9]{1}'
exit 1
### s_label=${student_name}-key
### s_key=${student_name}-key
### echo "Delete key $s_key..."
### curl -s -H "Authorization: APIToken $v_token" -X POST $v_url/config/namespaces/shared/known_label/delete -d '{"namespace":"shared","value":"$s_label","key":"$s_key"}'
exit 1
echo "Delete namespace ..."
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
   -lso)
   f_echo "Listing ${student_name} objects ..."
   f_list_student_objects
   ;;
   -dso)
   if [ "$#" != 2 ]; then
    f_echo "Missing student name ... "
    exit 1
   fi
   f_echo "Deleting $2 objects ..."
   f_delete_single_student_objects $2
   ;;
   -del)
   f_echo "Deleting all student objects ..."
   f_delete_all_student_objects
   ;;
   -wadso)
   if [ "$#" != 2 ]; then
    f_echo "Missing student name ... "
    exit 1
   fi
   f_echo "Deleting WAAP $2 objects ..."
   f_waap_delete_single_student_objects $2
   ;;
   -wadall)
   f_echo "Deleting all WAAP student objects ..."
   f_waap_delete_all_student_objects
   ;;
   -wacre)
   if [ "$#" != 2 ]; then
    f_echo "Missing student name ... "
    exit 1
   fi
   f_echo "Creating first WAAP lab objects for $2 ..."
   f_waap_create_single_student_objects $2
   ;;
   *)
   ### f_usage
   ;;
 esac
 shift
done
f_echo "End ..."
