F5 Training F5 Distributed Cloud script Ver 1.0

Usage: ./class.sh -option

Options:

-tok                       Test token
-lan                       List all namespaces
-lsn                       List student namespaces
-lss <studentname>         List student sites
-lvs <studentname>         List student virtual sites (vpc)
-las <studentname>         List a student(s) details
-dss <studentname>         Disable student account
-ess <studentname>         Enable student account
-dis                       Disable all student accounts (20 secs per student)
-ena                       Enable all student accounts (ditto)
-lso                       List all student objects
-del                       Delete all student objects
-dso <studentname>         Delete single student objects
-adlst <studentname>       ADMIN - List student AWS VPC
-adcre234 <studentname>    ADMIN - Create labs 2-4 student objects
-adapp4 <studentname>      ADMIN - Apply AWS VPC site created in lab 4
-adcre7 <studentname> <Private DNS Name IPv4>  ADMIN - Create lab 7 student objects
-adcre8 <studentname>                          ADMIN - Create lab 8 student objects
-adcre10 <studentname>                         ADMIN - Create lab 10 student objects
-wadso <studentname>       WAAP - Delete single student objects
-wadall                    WAAP - Delete all student objects
-walst <studentname>       WAAP - List first labs student objects
-wacre <studentname>       WAAP - Create labs 1-3 student objects

Prerequisites:

1 - The API token must work, they expire, run the -tok option to check still valid
  - See https://docs.cloud.f5.com/docs/how-to/user-mgmt/credentials or Xyleme notes
  - on how to generate a token
2 - Relies on students naming their namespace correctly

Notes:

Run the single options and starting options to see what's there, then go to delete all
API calls are sent, with timers after them, so the script takes its time deleting each entry

student@pc14:~/f5xc/xc-admin-course/scripts$ ./class.sh -adcre7 student14 ip-172-31-14-85.ec2.internal
F5 Training F5 Distributed Cloud script Ver 1.0
Missing student name ...
student@pc14:~/f5xc/xc-admin-course/scripts$ vi class.sh
student@pc14:~/f5xc/xc-admin-course/scripts$ ./class.sh -adcre7 student14 ip-172-31-14-85.ec2.internal
F5 Training F5 Distributed Cloud script Ver 1.0
Creating ADMIN lab 7 objects for student14 ...
Creating Origin Pool for student14 ...
{"code":3,"details":[{"type_url":"type.googleapis.com/ves.io.stdlib.server.error.Error","value":"oField spec.port_choice fails rule ves.io.schema.rules.message.required_oneof constraint true due to value \u003cnil\u003e;2024-03-14 17:36:30.533224829 +0000 UTC m=+181414.572464969"}],"message":"Field spec.port_choice should be not nil, got nil in request."}End ...
student@pc14:~/f5xc/xc-admin-course/scripts$ vi class.sh
student@pc14:~/f5xc/xc-admin-course/scripts$ ./class.sh -adcre7 student14 ip-172-31-14-85.ec2.internal
F5 Training F5 Distributed Cloud script Ver 1.0
-adcre7 student14 ip-172-31-14-85.ec2.internal
Creating ADMIN lab 7 objects for student14 ...
Creating Origin Pool for student14 ...
{"code":3,"details":[{"type_url":"type.googleapis.com/ves.io.stdlib.server.error.Error","value":"oField spec.port_choice fails rule ves.io.schema.rules.message.required_oneof constraint true due to value \u003cnil\u003e;2024-03-14 17:38:15.209242003 +0000 UTC m=+181519.248482134"}],"message":"Field spec.port_choice should be not nil, got nil in request."}End ...
student@pc14:~/f5xc/xc-admin-course/scripts$ vi class.sh
student@pc14:~/f5xc/xc-admin-course/scripts$ ./class.sh -adcre7 student14 ip-172-31-14-85.ec2.internal
F5 Training F5 Distributed Cloud script Ver 1.0
Student name: student14

IP DNS name: ip-172-31-14-85.ec2.internal
Creating ADMIN lab 7 objects for student14 ...
Creating Origin Pool for student14 ...
{"code":3,"details":[{"type_url":"type.googleapis.com/ves.io.stdlib.server.error.Error","value":"oField spec.port_choice fails rule ves.io.schema.rules.message.required_oneof constraint true due to value \u003cnil\u003e;2024-03-14 17:40:29.779251683 +0000 UTC m=+181653.818491823"}],"message":"Field spec.port_choice should be not nil, got nil in request."}End ...
student@pc14:~/f5xc/xc-admin-course/scripts$ vi class.sh
student@pc14:~/f5xc/xc-admin-course/scripts$ ./class.sh -adcre7 student14 ip-172-31-14-85.ec2.internal
F5 Training F5 Distributed Cloud script Ver 1.0
Student name: student14
IP DNS name: ip-172-31-14-85.ec2.internal
Creating ADMIN lab 7 objects for student14 ...
Creating Origin Pool for student14 ...
{"code":3,"details":[{"type_url":"type.googleapis.com/ves.io.stdlib.server.error.Error","value":"oField spec.port_choice fails rule ves.io.schema.rules.message.required_oneof constraint true due to value \u003cnil\u003e;2024-03-14 17:42:01.456137701 +0000 UTC m=+181745.495377832"}],"message":"Field spec.port_choice should be not nil, got nil in request."}End ...
student@pc14:~/f5xc/xc-admin-course/scripts$ vi class.sh
student@pc14:~/f5xc/xc-admin-course/scripts$ ./class.sh -adcre7 student14 ip-172-31-14-85.ec2.internal
F5 Training F5 Distributed Cloud script Ver 1.0
Student name: student14
IP DNS name: ip-172-31-14-85.ec2.internal
Creating ADMIN lab 7 objects for student14 ...
Creating Origin Pool for student14 ...
{"code":3,"details":[{"type_url":"type.googleapis.com/ves.io.stdlib.server.error.Error","value":"oField spec.port_choice fails rule ves.io.schema.rules.message.required_oneof constraint true due to value \u003cnil\u003e;2024-03-14 17:46:47.376251182 +0000 UTC m=+182031.415491312"}],"message":"Field spec.port_choice should be not nil, got nil in request."}End ...
student@pc14:~/f5xc/xc-admin-course/scripts$ vi class.sh
student@pc14:~/f5xc/xc-admin-course/scripts$ ./class.sh -adcre7 student14 ip-172-31-14-85.ec2.internal
F5 Training F5 Distributed Cloud script Ver 1.0
Student name: student14
IP DNS name: ip-172-31-14-85.ec2.internal
Creating ADMIN lab 7 objects for student14 ...
Creating Origin Pool for student14 ...
{"code":3,"details":[{"type_url":"type.googleapis.com/ves.io.stdlib.server.error.Error","value":"oField spec.port_choice fails rule ves.io.schema.rules.message.required_oneof constraint true due to value \u003cnil\u003e;2024-03-14 17:49:24.203516517 +0000 UTC m=+182188.242756718"}],"message":"Field spec.port_choice should be not nil, got nil in request."}End ...
student@pc14:~/f5xc/xc-admin-course/scripts$ vi class.sh
student@pc14:~/f5xc/xc-admin-course/scripts$ ./class.sh -adcre7 student14 ip-172-31-14-85.ec2.internal
F5 Training F5 Distributed Cloud script Ver 1.0
Student name: student14
IP DNS name: ip-172-31-14-85.ec2.internal
Creating ADMIN lab 7 objects for student14 ...
Creating Origin Pool for student14 ...
{"code":3,"details":[{"type_url":"type.googleapis.com/ves.io.stdlib.server.error.Error","value":"oField spec.port_choice fails rule ves.io.schema.rules.message.required_oneof constraint true due to value \u003cnil\u003e;2024-03-14 17:50:21.387927827 +0000 UTC m=+182245.427167979"}],"message":"Field spec.port_choice should be not nil, got nil in request."}End ...
student@pc14:~/f5xc/xc-admin-course/scripts$ vi class.sh
student@pc14:~/f5xc/xc-admin-course/scripts$ ./class.sh -adcre7 student14 ip-172-31-14-85.ec2.internal
F5 Training F5 Distributed Cloud script Ver 1.0
Student name: student14
IP DNS name: ip-172-31-14-85.ec2.internal
Creating ADMIN lab 7 objects for student14 ...
Creating Origin Pool for student14 ...
{"code":3,"details":[{"type_url":"type.googleapis.com/ves.io.stdlib.server.error.Error","value":"oField spec.port_choice fails rule ves.io.schema.rules.message.required_oneof constraint true due to value \u003cnil\u003e;2024-03-14 17:57:13.596124988 +0000 UTC m=+182657.635365117"}],"message":"Field spec.port_choice should be not nil, got nil in request."}End ...
student@pc14:~/f5xc/xc-admin-course/scripts$ vi class.sh
student@pc14:~/f5xc/xc-admin-course/scripts$ ./class.sh -adcre7 student14 ip-172-31-14-85.ec2.internal
F5 Training F5 Distributed Cloud script Ver 1.0
Student name: student14
IP DNS name: ip-172-31-14-85.ec2.internal
Creating ADMIN lab 7 objects for student14 ...
Creating Origin Pool for student14 ...
{"code":3,"details":[],"message":"invalid character '}' looking for beginning of object key string"}End ...
student@pc14:~/f5xc/xc-admin-course/scripts$ vi class.sh
student@pc14:~/f5xc/xc-admin-course/scripts$ ./class.sh -adcre7 student14 ip-172-31-14-85.ec2.internal
F5 Training F5 Distributed Cloud script Ver 1.0
Student name: student14
IP DNS name: ip-172-31-14-85.ec2.internal
Creating ADMIN lab 7 objects for student14 ...
Creating Origin Pool for student14 ...
{"code":3,"details":[],"message":"invalid character ']' after object key:value pair"}End ...
student@pc14:~/f5xc/xc-admin-course/scripts$ cat class.sh
#!/bin/bash

### set -e

### variables

product_name="F5 Distributed Cloud"
script_ver="1.0"
script_name="class.sh"
student_name=$2

### This script is built to handle both production and development sites in XC and AWS
### Need to comment out variables to switch between them

### Points to the Training Devopment F5XC console which points to the Internal Training AWS instance
### v_token="CfxhI08CzaktknCrXwsrCmOPibI="
### v_url="https://training-dev.console.ves.volterra.io/api"
### v_tenant=""training-dev-fcphvhww"

### Points to the public Training F5XC console which points to the Training AWS instance
v_token="9F9igLid8gdh9ZJZNJAlLUOaxSs="
v_url="https://training.console.ves.volterra.io/api"
v_tenant="training-ytfhxsmw"


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
echo "-adlst <studentname>       ADMIN - List student AWS VPC"
echo "-adcre234 <studentname>    ADMIN - Create labs 2-4 student objects"
echo "-adapp4 <studentname>      ADMIN - Apply AWS VPC site created in lab 4"
echo "-adcre7 <studentname> <Private DNS Name IPv4>  ADMIN - Create lab 7 student objects"
echo "-adcre8 <studentname>                          ADMIN - Create lab 8 student objects"
echo "-adcre10 <studentname>                         ADMIN - Create lab 10 student objects"
echo "-wadso <studentname>       WAAP - Delete single student objects"
echo "-wadall                    WAAP - Delete all student objects"
echo "-walst <studentname>       WAAP - List first labs student objects"
echo "-wacre <studentname>       WAAP - Create labs 1-3 student objects"
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

f_admin_list_single_student_aws_vpc()
{
singleordouble=`echo $1 | wc -m`
if [ $singleordouble -eq 10 ]; then
 snum=`echo -n $1 | tail -c 2`
 pnum="10$snum"
else
 snum=`echo -n $1 | tail -c 1`
 pnum="100$snum"
fi
s_aws_vpc_name="$1-vpc"
### aws vpc objects are created tn the system namesapce, not shared, not student
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/system/aws_vpc_sites"
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/system/aws_vpc_sites/$s_aws_vpc_name"
}

f_admin_create_single_student_objects_labs234()
{
### Create labs 2-4 for a student
singleordouble=`echo $1 | wc -m`
if [ $singleordouble -eq 10 ]; then
 snum=`echo -n $1 | tail -c 2`
 pnum="10$snum"
else
 snum=`echo -n $1 | tail -c 1`
 pnum="100$snum"
fi
echo "Creating Namespace for $1 ..."
### curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/web/namespaces" -d '{"metadata":{"name":"'$1'"},"spec":{}}' | jq
sleep 1
echo "Creating Key and Label for $1 ..."
s_key="$1-key"
s_value="$1-value"
s_vsite_name="$1-vsite"
s_aws_vpc_name="$1-vpc"
### curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/shared/known_label_key/create" -d '{"key":"'$s_key'","namespace":"'$1'"}'
sleep 1
### curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/shared/known_label/create" -d '{"key":"'$s_key'","namespace":"'$1'","value":"'$s_value'"}'
sleep 1
echo "Creating Virtual Site of type CE for $1 ..."
sleep 1
### curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/shared/virtual_sites" -d '{"metadata":{"name":"'$s_vsite_name'","namespace":"'$1'"},"spec":{"site_selector":{"expressions":["'$s_key' in ('$s_value')"]},"site_type":"CUSTOMER_EDGE"}}'
sleep 2
s_ssh_key="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDc+HSquvm6Bbvnk4h2KMR51MwnzBPWzbmhK5tiW8sC4rh+VzrcjNgnrc4Op7tFtLkv2sq/Vecg9QB6jMamGoBrqWP3qjejSxYWwr8xP/ZNRlqJNwGxEAQlDkUkKtUfNWgmOZtoVq249vvewyUCbmOlpgFDPPeNGfQrutJkOHmUj53kEIhhkoE+ZieY2Ls5fHTNgUDznf8KysnrIAr+reEKt7FREL+4kKnCp9ZlZtw/nw5sSDFNU9PRZuTwZIE85oY9nDxe9fRRttBSMHq9g0GD0iZg9fjafuB0Ft7qzkSq20vGrtYxfGgPW8kIjZBA95CSyA2gRsnSxUF7Fq+W50EWZfqU4O9KOZwKo8dTcbjmS+S5S5avK37uVn1v99rdG3Z9xbfBW8tohARDGlzC1R1Qh+LrfPgjds7oKXewT6hiHDe0wsMp25IxYUGEHqdEaAs4Bfos4Qw2Lwhjc2brNAO1aD9VpQPf9RMkv+gEDLoWdLEHw+qpRInDcO1N3kt8bQM= student@PC01"
### The API call pukes with an unexpected EOF if we directly refer to the SSH key variable, its reading the spaces as
### a newline or carraige return. If you manually cut the contents into the API it works but thats cumbersome
### ns_ssh_key=`echo -n -E $s_ssh_key`
### ns_ssh_key=`echo $s_ssh_key`
### Could not find a away around this problem
echo "Creating AWS VPC Site configuration for $1 ..."
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/system/aws_vpc_sites" -d '{"metadata":{"name":"'$s_aws_vpc_name'","namespace":"system","labels":{"'$s_key'":"'$s_value'"}},"spec":{ "vpc": {"new_vpc": {"autogenerate": {},"primary_ipv4": "172.31.0.0/16","allocate_ipv6": false}},"ingress_gw": {"az_nodes": [{"aws_az_name": "us-east-1a","local_subnet": {"subnet_param": {"ipv4": "172.31.14.0/24","ipv6": ""}},"disk_size": 0}],"aws_certified_hw": "aws-byol-voltmesh","allowed_vip_port":{ "use_http_https_port": {}},"performance_enhancement_mode": {"perf_mode_l7_enhanced": {}}},"aws_cred":{"tenant":"training-ytfhxsmw","namespace":"system","name":"learnf5-aws"},"instance_type":"m5.4xlarge","disk_size":0,"volterra_software_version":"","operating_system_version":"","aws_region":"us-east-1","ssh_key":"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDc+HSquvm6Bbvnk4h2KMR51MwnzBPWzbmhK5tiW8sC4rh+VzrcjNgnrc4Op7tFtLkv2sq/Vecg9QB6jMamGoBrqWP3qjejSxYWwr8xP/ZNRlqJNwGxEAQlDkUkKtUfNWgmOZtoVq249vvewyUCbmOlpgFDPPeNGfQrutJkOHmUj53kEIhhkoE+ZieY2Ls5fHTNgUDznf8KysnrIAr+reEKt7FREL+4kKnCp9ZlZtw/nw5sSDFNU9PRZuTwZIE85oY9nDxe9fRRttBSMHq9g0GD0iZg9fjafuB0Ft7qzkSq20vGrtYxfGgPW8kIjZBA95CSyA2gRsnSxUF7Fq+W50EWZfqU4O9KOZwKo8dTcbjmS+S5S5avK37uVn1v99rdG3Z9xbfBW8tohARDGlzC1R1Qh+LrfPgjds7oKXewT6hiHDe0wsMp25IxYUGEHqdEaAs4Bfos4Qw2Lwhjc2brNAO1aD9VpQPf9RMkv+gEDLoWdLEHw+qpRInDcO1N3kt8bQM= student@PC01","address": "","logs_streaming_disabled":{},"site_state": "WAITING_FOR_REGISTRATION","vip_params_per_az": [],"user_modification_timestamp": null,"tags": {},"no_worker_nodes": {},"default_blocked_services": {},"direct_connect_disabled": {},"offline_survivability_mode": {"no_offline_survivability_mode": {}},"enable_internet_vip": {},"egress_gateway_default": {},"suggested_action": "", "error_description": "", "f5xc_security_group": {},"cloud_site_info": {"public_ips": [],"private_ips": [],"subnet_ids": [],"vpc_id": "","vpc_name": "ves-vpc-auto-student14-vpc"},"direct_connect_info": null}}'
### Ridiculous, most of these settings are not needed or are default anyway
### curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/system/aws_vpc_sites" -d '{"metadata":{"name":"'$s_aws_vpc_name'","namespace":"system","labels":{"'$s_key'":"'$s_value'"}},"spec":{ "vpc": {"new_vpc": {"autogenerate": {},"primary_ipv4": "172.31.0.0/16","allocate_ipv6": false}},"ingress_gw": {"az_nodes": [{"aws_az_name": "us-east-1a","local_subnet": {"subnet_param": {"ipv4": "172.31.'$snum'.0/24","ipv6": ""}},"disk_size": 0}],"aws_certified_hw": "aws-byol-voltmesh","allowed_vip_port":{ "use_http_https_port": {}},"performance_enhancement_mode": {"perf_mode_l7_enhanced": {}}},"aws_cred": {"tenant":"'$v_tenant'","namespace":"system","name": "learnf5-aws"},"instance_type": "m5.4xlarge","aws_region": "us-east-1","ssh_key": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDc+HSquvm6Bbvnk4h2KMR51MwnzBPWzbmhK5tiW8sC4rh+VzrcjNgnrc4Op7tFtLkv2sq/Vecg9QB6jMamGoBrqWP3qjejSxYWwr8xP/ZNRlqJNwGxEAQlDkUkKtUfNWgmOZtoVq249vvewyUCbmOlpgFDPPeNGfQrutJkOHmUj53kEIhhkoE+ZieY2Ls5fHTNgUDznf8KysnrIAr+reEKt7FREL+4kKnCp9ZlZtw/nw5sSDFNU9PRZuTwZIE85oY9nDxe9fRRttBSMHq9g0GD0iZg9fjafuB0Ft7qzkSq20vGrtYxfGgPW8kIjZBA95CSyA2gRsnSxUF7Fq+W50EWZfqU4O9KOZwKo8dTcbjmS+S5S5avK37uVn1v99rdG3Z9xbfBW8tohARDGlzC1R1Qh+LrfPgjds7oKXewT6hiHDe0wsMp25IxYUGEHqdEaAs4Bfos4Qw2Lwhjc2brNAO1aD9VpQPf9RMkv+gEDLoWdLEHw+qpRInDcO1N3kt8bQM= student@PC01","address": "","logs_streaming_disabled": {},"site_state": "WAITING_FOR_REGISTRATION","vip_params_per_az": [],"user_modification_timestamp": null,"tags": {},"no_worker_nodes": {},"default_blocked_services": {},"direct_connect_disabled": {},"offline_survivability_mode": {"no_offline_survivability_mode": {}},"enable_internet_vip": {},"egress_gateway_default": {},"suggested_action": "", "error_description": "", "f5xc_security_group": {},"cloud_site_info": {"public_ips": [],"private_ips": [],"subnet_ids": [],"vpc_id": ""},"direct_connect_info": null}}'
sleep 2
echo ""
echo "The AWS VPC Site configuration needs to be APPLYied using the -adapp4 option for $1 ..."
}

f_admin_apply_single_student_objects_labs4()
{
### Apply labs 4 for a student
singleordouble=`echo $1 | wc -m`
if [ $singleordouble -eq 10 ]; then
 snum=`echo -n $1 | tail -c 2`
 pnum="10$snum"
else
 snum=`echo -n $1 | tail -c 1`
 pnum="100$snum"
fi
s_aws_vpc_name="$1-vpc"
echo "Status of Terraform Plan for AWS VPC Site configuration for $1 ..."
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/system/terraform_parameters/aws_vpc_site/$s_aws_vpc_name/status" | jq
sleep 2
echo "Applying Terraform Plan for AWS VPC Site configuration for $1 ..."
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/terraform/namespaces/system/terraform/aws_vpc_site/$s_aws_vpc_name/run" -d '{"action":"APPLY"}'
}

f_admin_create_single_student_objects_labs7()
{
### Create labs 7 for studentX
singleordouble=`echo $1 | wc -m`
if [ $singleordouble -eq 10 ]; then
 snum=`echo -n $1 | tail -c 2`
 pnum="10$snum"
else
 snum=`echo -n $1 | tail -c 1`
 pnum="100$snum"
fi
s_op="$1-tcp"
s_ipdns_name="$3"
echo "Creating Origin Pool for $1 ..."
### curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/$1/origin_pools/student$snum-tcp" | jq
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/shared/origin_pools" -d '{"metadata":{"name":"'$s_op'","namespace":"'$1'"},"spec":{"origin_servers":[{"private_name":{"dns_name":"'$s_ipdns_name'","site_locator":{"virtual_site":{"tenant":"'$v_tenant'","name":"'$1'-vsite","namespace":"shared"}},"outside_network":{},"labels":{}}],"port":22,"same_as_endpoint_port":{},"healthcheck":[],"loadbalancer_algorithm":"LB_OVERRIDE","endpoint_selection":"LOCAL_PREFERRED","advanced_options":null}}'
}

f_admin_create_single_student_objects_labs8()
{
### Create labs 7, 8, 10 for studentX
singleordouble=`echo $1 | wc -m`
if [ $singleordouble -eq 10 ]; then
 snum=`echo -n $1 | tail -c 2`
 pnum="10$snum"
else
 snum=`echo -n $1 | tail -c 1`
 pnum="100$snum"
fi
s_op="$1-tcp"
s_lp="$1-tcp-lb"
echo "Creating TCP Load Balancer for $1 ..."
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/$1/tcp_loadbalancers/student$snum-tcp-lb?report_fields" | jq
}

f_admin_create_single_student_objects_labs10()
{
### Create labs 10 for studentX
singleordouble=`echo $1 | wc -m`
if [ $singleordouble -eq 10 ]; then
 snum=`echo -n $1 | tail -c 2`
 pnum="10$snum"
else
 snum=`echo -n $1 | tail -c 1`
 pnum="100$snum"
fi
echo "Creating vk8s for $1 ..."
}

f_waap_delete_single_student_objects()
{
### Only need to delete student namespace to delete all objects
### If only delete the HTTP load balancer it removs half of the objects as well
### except when XC puts objects into shared space like App Firewalls sometimes and they are not deleted
echo "Deleting namespace ..."
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/web/namespaces" | jq -r .[][].name | grep -E $1
sleep 1
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/web/namespaces/$1/cascade_delete" | jq
echo "Run the -lso option again to check for object outliers and manually delete them ..."
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
echo "Run the -lso and -walst options again to check for object outliers and manually delete them ..."
}

f_waap_list_single_student_objects()
{
### List labs 1-3 per student
echo "Listing all namespaces ..."
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/web/namespaces" | jq -r .[][].name
echo "Searching namespaces for $1 ..."
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/web/namespaces" | jq -r .[][].name | grep -E "student$i"
exit 1
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/$1/http_loadbalancers?report_fields" | jq
sleep 1
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/$1/origin_pools" | jq
sleep 1
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/$1/healthchecks?report_fields" | jq
sleep 1
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/$1/origin_pools/$1-juice-originpool?report_fields" | jq
sleep 1
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/ml/data/namespaces/$1/http_loadbalancers/$1-juice-lb/api_endpoints" | jq
sleep 1
}

f_waap_create_single_student_objects()
{
### Create labs 1-3 for a student
### Create the port number for the origin pool range is 1001 to 1012
### Tenant matters for JuiceShop check which tenant environment we are using
### WAAP Lab 3 uses either studentX-juice.aws.learnf5.cloud or studentX-juice.dev.learnf5.cloud
####fqdn="$1-juice.dev.learnf5.cloud"
fqdn="$1-juice.aws.learnf5.cloud"
### Handle student names between 1-12 studentX has 9 chars, studentXX has 10
singleordouble=`echo $1 | wc -m`
if [ $singleordouble -eq 10 ]; then
 snum=`echo -n $1 | tail -c 2`
 pnum="10$snum"
else
 snum=`echo -n $1 | tail -c 1`
 pnum="100$snum"
fi
echo "Creating Namespace for $1 ..."
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/web/namespaces" -d '{"metadata":{"name":"'$1'"},"spec":{}}' | jq
sleep 1
### have to create OP, Origin server, health check beforehand and reference in load balancer
echo "Creating Health check for HTTP Load Balancer for $1 ..."
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$1/healthchecks" -d '{"metadata":{"name":"'$1'-hc"},"spec":{"healthy_threshold":3,"http_health_check":{"expected_status_codes":["200"],"path":"/"},"interval":15,"timeout":3,"jitter_percent":30,"unhealthy_threshold":1}}' | jq
sleep 1
echo "Creating Origin Pool and Origin Server for HTTP Load Balancer for $1 ..."
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$1/origin_pools" -d '{"metadata":{"name":"'$1'-juice-originpool"},"spec":{"gc_spec":{},"origin_servers":[{"public_ip":{"ip":"23.22.60.254"},"labels":{}}],"port":"'$pnum'","healthcheck":[{"namespace":"'$1'","name":"'$1'-hc"}]}}' | jq
sleep 1
echo "Creating HTTP Load Balancer for $1 ..."
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$1/http_loadbalancers" -d '{ "metadata":{"name":"'$1'-juice-lb","namespace":"'$1'"},"spec":{"domains":["'$fqdn'"],"https_auto_cert":{"add_hsts":true,"http_redirect":true},"port":"443","default_route_pools":[{"pool":{"namespace":"'$1'","name":"'$1'-juice-originpool"},"weight":"1","priority":"1"}],"add_location":true,"enable_api_discovery":{"enable_learn_from_redirect_traffic":{},"discovered_api_settings":{"purge_duration_for_inactive_discovered_apis":2}}} }' | jq
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
   -adlst)
   if [ "$#" != 2 ]; then
    f_echo "Missing student name ... "
    exit 1
   fi
   f_echo "Listing AWS VPC site for $2 ..."
   f_admin_list_single_student_aws_vpc $2
   ;;
   -adcre234)
   if [ "$#" != 2 ]; then
    f_echo "Missing student name ... "
    exit 1
   fi
   f_echo "Creating ADMIN labs 2-4 objects for $2 ..."
   f_admin_create_single_student_objects_labs234 $2
   ;;
   -adapp4)
   if [ "$#" != 2 ]; then
    f_echo "Missing student name ... "
    exit 1
   fi
   f_echo "Applying ADMIN lab 4 AWS VPC site objects for $2 ..."
   f_admin_apply_single_student_objects_labs4 $2
   ;;
   -adcre7)
   if [ "$#" != 3 ]; then
    f_echo "Either missing student name or private IP DNS name ... "
    exit 1
   fi
   echo Student name: $2
   echo IP DNS name: $3
   f_echo "Creating ADMIN lab 7 objects for $2 ..."
   f_admin_create_single_student_objects_labs7 $2 $3
   ;;
   -adcre8)
   if [ "$#" != 2 ]; then
    f_echo "Missing student name ... "
    exit 1
   fi
   f_echo "Creating ADMIN labs 8 objects for $2 ..."
   f_admin_create_single_student_objects_labs8 $2
   ;;
   -adcre10)
   if [ "$#" != 2 ]; then
    f_echo "Missing student name ... "
    exit 1
   fi
   f_echo "Creating ADMIN lab 10 objects for $2 ..."
   f_admin_create_single_student_objects_labs10 $2
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
   f_echo "Creating WAAP labs 1-3 objects for $2 ..."
   f_waap_create_single_student_objects $2
   ;;
   -walst)
   if [ "$#" != 2 ]; then
    f_echo "Missing student name ... "
    exit 1
   fi
   f_echo "List first WAAP lab objects for $2 ..."
   f_waap_list_single_student_objects $2
   ;;
   *)
   ### f_usage
   ;;
 esac
 shift
done
f_echo "End ..."
