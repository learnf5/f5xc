#!/bin/bash

### variables

product_name="F5 Distributed Cloud"
script_ver="1.4"
script_name="class2.sh"
student_name=$2

### Points to classroom 2

v_token="FREqRwnm8mg83l8C+cGJlwPCSLQPt3w="
v_url="https://training2.console.ves.volterra.io/api"
v_tenant="training2-haiyaqtr"
v_dom="f5training2.cloud"
v_aws_creds_name="creds-aws1211gst02"
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
echo "Classroom 2 setup script for Admin and WAAP"
echo ""
echo "Student numbers run from 201 to 212"
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
echo "-las <studentname>         List student details"
echo "-dss <studentname>         Disable student account"
echo "-ess <studentname>         Enable student account"
echo "-dis                       Disable all student accounts (20 secs per student)"
echo "-ena                       Enable all student accounts (ditto)"
echo "-lso                       List all student objects"
echo ""
echo "-adlst <studentname>       ADMIN - List student AWS VPC"
echo "-adcre23 <studentname>     ADMIN - Create labs 2-3 and do 4 manually"
echo "-adcre234 <studentname>    ADMIN - Create labs 2-4 student objects"
echo "-adapp4 <studentname>      ADMIN - Apply AWS VPC site created in lab 4"
echo "-adcre7 <studentname>      ADMIN - Create lab 7 student objects - manual"
echo "-adkub7 <studentname>      ADMIN - Create Lab 7 student objects - automatic"
echo "-adcre9 <studentname>      ADMIN - Create lab 9 student objects"
echo "-adcre10 <studentname>     ADMIN - Create lab 10 student objects"
echo "-adcre11 <studentname>     ADMIN - Create lab 11 student objects"
echo "-adcre14 <studentname>     ADMIN - Create lab 14 student objects"
echo "-adcreall <studentname>    ADMIN - Create all ADMIN class labs per student"
echo "-adcreall12                ** Under construction ADMIN - Create all Admin class labs for 12 students"
echo "-adlstd <studentname>      ADMIN - List student vK8s deployments and other details"
echo "-addso <studentname>       ADMIN - Delete single student objects"
echo "-addas                     ADMIN - Delete all student objects (max 12)"
echo ""
echo "-wadso <studentname>       WAAP - Delete single student objects"
echo "-wadall                    WAAP - Delete all student objects"
echo "-walst <studentname>       WAAP - List first labs student objects"
echo "-wacre <studentname>       WAAP - Create labs 1-3 student objects"
echo ""
echo "Prerequisites:"
echo ""
echo "1 - The API token must work, they expire, run the -tok option to check still valid"
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
curl -s -H "Authorization: APIToken $v_token" -X GET $v_url/config/namespaces/${student_name}/sites | jq -r .[][].name |grep -E 'student[1-9]{1}'
}

f_list_student_vpc_sites()
{
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
for i in {201..212}
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
echo "Known Active Alert policies ..."
### curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/shared/alert_policys" | jq -r .[][].name | grep -E 'student[1-9]{1}'
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
curl -s -H "Authorization: APIToken $v_token" -X DELETE "$v_url/config/namespaces/$1/app_firewalls/$1-waf" | jq
sleep 2
### There are 4 types of receivers and policies, namespace and tenant levels
### This is annoying there are 3 locations for the 4 obects, 2 pairs of alert receivers and policies
### Some are in individual namepace, some are in shared, some are in system
echo "Known Alert receivers ..."
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/system/alert_receivers" | jq -r .[][].name | grep -E 'student[1-9]{1}'
sleep 2
echo "Known Alert policies ..."
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/shared/alert_policys" | jq -r .[][].name | grep -E 'student[1-9]{1}'
sleep 2
echo "Deleting Alert Receiver tenant level ..."
curl -s -H "Authorization: APIToken $v_token" -X DELETE "$v_url/config/namespaces/shared/alert_receivers/$1-tenant-alert-receiver" | jq
sleep 2
echo "Deleting Alert Policy tenant level ..."
curl -s -H "Authorization: APIToken $v_token" -X DELETE "$v_url/config/namespaces/shared/alert_policys/$1-tenant-alert-policy" | jq
sleep 2
echo "Deleting Alert Receiver namespace level ..."
curl -s -H "Authorization: APIToken $v_token" -X DELETE "$v_url/config/namespaces/$1/alert_receivers/$1-ns-alert-receiver" | jq
sleep 2
echo "Deleting Alert Policy namespace level..."
curl -s -H "Authorization: APIToken $v_token" -X DELETE "$v_url/config/namespaces/$1/alert_policys/$1-tenant-alert-policy" | jq
sleep 2
### We do create one per lab BUT we specify a namespace level policy which is already deleted
### So there is nothing to delete except we have seen odd behaviour in this UI, check manually
echo "Deleting Active Alert Policy ..."
echo "This should refer to a previous namespace policy that was just deleted ..."
echo "Deleting TCP load balancer ..."
curl -s -H "Authorization: APIToken $v_token" -X DELETE "$v_url/config/namespaces/$1/tcp_loadbalancers/$1-tcp-lb" | jq
sleep 2
echo "Deleting HTTP load balancer ..."
sleep 2
curl -s -H "Authorization: APIToken $v_token" -X DELETE "$v_url/config/namespaces/$1/http_loadbalancers/$1-https-lb" | jq
sleep 2
echo "Deleting Origin pools  ..."
curl -s -H "Authorization: APIToken $v_token" -X DELETE "$v_url/config/namespaces/$1/origin_pools/$1-op" | jq
sleep 2
curl -s -H "Authorization: APIToken $v_token" -X DELETE "$v_url/config/namespaces/$1/origin_pools/$1-op2" | jq
sleep 2
echo "Deleting Health checks  ..."
curl -s -H "Authorization: APIToken $v_token" -X DELETE "$v_url/config/namespaces/$1/healthchecks/$1-hc" | jq
sleep 2
echo "Deleting Known label ..."
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/shared/known_label/delete" -d '{"namespace":"shared","value":"'$1'-value","key":"'$1'-key"}'
sleep 2
echo "Deleting Known key ..."
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/shared/known_label_key/delete" -d '{"namespace":"shared","key":"'$1'-key"}'
sleep 2
echo "Deleting AWS VPC site ..."
curl -s -H "Authorization: APIToken $v_token" -X DELETE "$v_url/config/namespaces/system/aws_vpc_sites/$1-vpc" | jq
sleep 2
echo "Deleting Virtual site ..."
curl -s -H "Authorization: APIToken $v_token" -X DELETE "$v_url/config/namespaces/shared/virtual_sites/$1-vsite" | jq
sleep 2
echo "Deleting vK8s ..."
curl -s -H "Authorization: APIToken $v_token" -X DELETE "$v_url/config/namespaces/$1/virtual_k8ss/$1-vk8s" | jq
sleep 2
echo "Deleting namespace ..."
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/web/namespaces/$1/cascade_delete" | jq
sleep 2
echo "Listing API credentials ..."
### These are generated with random names, however both have studentX in them
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/web/namespaces/system/api_credentials" | jq -r .[][].name | grep -E $1
sleep 1
echo "Revoking API credentials ..."
apicreds_list="$(curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/web/namespaces/system/api_credentials" | jq -r .[][].name | grep -E $1)"
for apicred_name in ${apicreds_list[@]}; do
 curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/web/namespaces/system/revoke/api_credentials" -d '{"name":"'$apicred_name'"}' | jq
done
echo "End of object list ..."
echo ""
echo "The AWS VPC object needs to be deleted TWICE; the first queues a delete of the AWS instance, "
echo "this takes up to 10 mins to do depending on load. The second deletes the F5XC object, so run "
echo "this option again after say 10 mins for the second delete"
echo ""
echo ". . . OR . . . delete the student AWS VPC object via the GUI, probably quicker"
echo ""
}

f_delete_all_student_objects()
{
for count in {201..212}
do
 echo "Deleting objects for student$count ..."
 f_delete_single_student_objects student$count
 echo "Done ..."
done
echo "First pass done ..."
for count in {201..212}
do
 echo "Deleting objects again for student$count ..."
 f_delete_single_student_objects student$count
 echo "Done ..."
done
echo "Second pass done ..."
}

f_admin_list_single_student_aws_vpc()
{
s_aws_vpc_name="$1-vpc"
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/system/aws_vpc_sites/$s_aws_vpc_name"
}

f_admin_create_single_student_objects_labs23()
{
### Create labs 2-3 for a student
snumdigits=`echo $1 | wc -m`
if [ $snumdigits -eq 11 ]; then
 snum=`echo -n $1 | tail -c 3`
 pnum="1$snum"
elif
 [ $snumdigits -eq 10 ]; then
 snum=`echo -n $1 | tail -c 2`
 pnum="10$snum"
else
 snum=`echo -n $1 | tail -c 1`
 pnum="100$snum"
fi
echo "Creating Namespace for $1 ..."
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/web/namespaces" -d '{"metadata":{"name":"'$1'"},"spec":{}}' | jq
sleep 1
echo "Creating Key and Label for $1 ..."
s_key="$1-key"
s_value="$1-value"
s_vsite_name="$1-vsite"
s_aws_vpc_name="$1-vpc"
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/shared/known_label_key/create" -d '{"key":"'$s_key'","namespace":"'$1'"}'
sleep 1
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/shared/known_label/create" -d '{"key":"'$s_key'","namespace":"'$1'","value":"'$s_value'"}'
sleep 1
echo "Creating Virtual Site of type CE for $1 ..."
sleep 1
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/shared/virtual_sites" -d '{"metadata":{"name":"'$s_vsite_name'","namespace":"'$1'"},"spec":{"site_selector":{"expressions":["'$s_key' in ('$s_value')"]},"site_type":"CUSTOMER_EDGE"}}'
echo ""
echo "The AWS VPC Site needs to be created manually in Lab 4 for $1 ..."
}

f_admin_create_single_student_objects_labs234()
{
### Create labs 2-4 for a student
snumdigits=`echo $1 | wc -m`
if [ $snumdigits -eq 11 ]; then
 snum=`echo -n $1 | tail -c 3`
 pnum="1$snum"
elif
 [ $snumdigits -eq 10 ]; then
 snum=`echo -n $1 | tail -c 2`
 pnum="10$snum"
else
 snum=`echo -n $1 | tail -c 1`
 pnum="100$snum"
fi
echo "Creating Namespace for $1 ..."
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/web/namespaces" -d '{"metadata":{"name":"'$1'"},"spec":{}}' | jq
sleep 1
echo "Creating Key and Label for $1 ..."
s_key="$1-key"
s_value="$1-value"
s_vsite_name="$1-vsite"
s_aws_vpc_name="$1-vpc"
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/shared/known_label_key/create" -d '{"key":"'$s_key'","namespace":"'$1'"}'
sleep 1
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/shared/known_label/create" -d '{"key":"'$s_key'","namespace":"'$1'","value":"'$s_value'"}'
sleep 1
echo "Creating Virtual Site of type CE for $1 ..."
sleep 1
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/shared/virtual_sites" -d '{"metadata":{"name":"'$s_vsite_name'","namespace":"'$1'"},"spec":{"site_selector":{"expressions":["'$s_key' in ('$s_value')"]},"site_type":"CUSTOMER_EDGE"}}'
sleep 1
echo "Creating AWS VPC Site configuration for $1 ..."
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/system/aws_vpc_sites" -d '{"metadata":{"name":"'$s_aws_vpc_name'","namespace":"system","labels":{"'$s_key'":"'$s_value'"}},"spec":{"vpc":{"new_vpc":{"autogenerate":{},"primary_ipv4":"172.31.0.0/16","allocate_ipv6":false}},"ingress_gw":{"az_nodes":[{"aws_az_name":"us-east-1a","local_subnet":{"subnet_param":{"ipv4":"172.31.'$snum'.0/24"}},"disk_size":0}],"aws_certified_hw":"aws-byol-voltmesh","allowed_vip_port":{"use_http_https_port":{}},"performance_enhancement_mode":{"perf_mode_l7_enhanced":{}}},"aws_cred":{"tenant":"'$v_tenant'","namespace":"system","name":"'$v_aws_creds_name'"},"instance_type":"m5.4xlarge","disk_size":0,"volterra_software_version":"","operating_system_version":"","aws_region":"us-east-1","ssh_key":"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDc+HSquvm6Bbvnk4h2KMR51MwnzBPWzbmhK5tiW8sC4rh+VzrcjNgnrc4Op7tFtLkv2sq/Vecg9QB6jMamGoBrqWP3qjejSxYWwr8xP/ZNRlqJNwGxEAQlDkUkKtUfNWgmOZtoVq249vvewyUCbmOlpgFDPPeNGfQrutJkOHmUj53kEIhhkoE+ZieY2Ls5fHTNgUDznf8KysnrIAr+reEKt7FREL+4kKnCp9ZlZtw/nw5sSDFNU9PRZuTwZIE85oY9nDxe9fRRttBSMHq9g0GD0iZg9fjafuB0Ft7qzkSq20vGrtYxfGgPW8kIjZBA95CSyA2gRsnSxUF7Fq+W50EWZfqU4O9KOZwKo8dTcbjmS+S5S5avK37uVn1v99rdG3Z9xbfBW8tohARDGlzC1R1Qh+LrfPgjds7oKXewT6hiHDe0wsMp25IxYUGEHqdEaAs4Bfos4Qw2Lwhjc2brNAO1aD9VpQPf9RMkv+gEDLoWdLEHw+qpRInDcO1N3kt8bQM= student@PC01","address":"","logs_streaming_disabled":{},"vip_params_per_az":[],"no_worker_nodes": {},"default_blocked_services":{},"direct_connect_disabled":{},"offline_survivability_mode":{"no_offline_survivability_mode":{}},"enable_internet_vip":{},"egress_gateway_default":{},"suggested_action":"","error_description":"", "f5xc_security_group":{},"direct_connect_info":null}}'
sleep 1
echo ""
echo "The AWS VPC Site configuration needs to be APPLYied using the -adapp4 option for $1 ..."
}

f_admin_apply_single_student_objects_labs4()
{
### Apply labs 4 for a student
snumdigits=`echo $1 | wc -m`
if [ $snumdigits -eq 11 ]; then
 snum=`echo -n $1 | tail -c 3`
 pnum="1$snum"
elif
 [ $snumdigits -eq 10 ]; then
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
sleep 2
echo ""
echo "Check the GUI for the green Apply button and check AWS. Process takes some minutes to run ..."
}

f_admin_create_single_student_objects_labs7()
{
### Create labs 7 for studentX
s_vk8s="$1-vk8s"
echo "Creating vk8s for $1 ..."
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$1/virtual_k8ss" -d '{"metadata":{"name":"'$s_vk8s'","namespace":"'$1'"},"spec":{"vsite_refs":[{"kind":"virtual_site","uid":"","tenant":"'$v_tenant'","namespace":"shared","name":"'$1'-vsite"}],"disabled":{},"default_flavor_ref":null}}'
echo ""
echo "Now go to Distributed Apps > student namespace > Applications > Virtual K8s, wait for the create to finish then click 3 dots, Kubeconfig, download the file to the workstation and finish Lab 10 ..."
echo ""
echo "Then run these commands:"
echo ""
echo "cd /home/student/.kube"
echo "mv /mnt/c/Users/student/Downloads/ves_studentX_studentX-vk8s.yaml ./config"
echo "cd /home/student/f5xc/xc-admin-course"
echo "kubectl apply -f online-boutique.yaml"
echo ""
echo "Or ...:"
echo ""
echo "Copy and paste these:"
echo ""
echo "cd /home/student/.kube; mv /mnt/c/Users/student/Downloads/ves_$1_$1-vk8s.yaml ./config; cd /home/student/f5xc/xc-admin-course; kubectl apply -f online-boutique.yaml --dry-run=server; kubectl apply -f online-boutique.yaml; cd scripts"
echo ""
echo "Or ...:"
echo ""
echo "Confirm the vK8s object is created - it takes some time"
echo ""
echo "Run the -adkub7 option and it downloads the kubeconfig and deploys the application automatically"
echo ""
}

f_admin_create_single_student_kubeconfig_lab7()
{
s_vk8s="$1-vk8s"
echo "Creating vk8s for $1 ..."
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$1/virtual_k8ss" -d '{"metadata":{"name":"'$s_vk8s'","namespace":"'$1'"},"spec":{"vsite_refs":[{"kind":"virtual_site","uid":"","tenant":"'$v_tenant'","namespace":"shared","name":"'$1'-vsite"}],"disabled":{},"default_flavor_ref":null}}'
echo ""
echo "The vK8s object must exist for the next steps to work. Sleeping for 60 ..."
f_dots 60
echo ""
echo "Downloading vK8s Kubeconfig file for $1 ..."
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/web/namespaces/$1/api_credentials" -d '{"name":"'$s_vk8s'","namespaces":"system","expiration_days":10,"spec":{"type":"KUBE_CONFIG","users":[],"password":null,"virtual_k8s_name":"'$s_vk8s'","virtual_k8s_namespace":"'$1'"}}' 1>encoded_ves_$1_$1-vk8s.yaml 2>kubeconfig.error
echo "Takes a while ..."
sleep 5
### cat encoded_ves_$1_$1-vk8s.yaml
### cat kubeconfig.error
sleep 2
echo "Decoding file ..."
cat encoded_ves_$1_$1-vk8s.yaml | jq -r '.[]' | sed '/'$1'/q' | sed '/==/q' | base64 --decode 1>ves_$1_$1-vk8s.yaml
sleep 1
### cat ves_$1_$1-vk8s.yaml
echo "Copying kubeconfig file to /home/student/.kube/config ..."
cp ves_$1_$1-vk8s.yaml /home/student/.kube/config
sleep 1
echo "Deploying online-boutique application ..."
cd /home/student/f5xc/xc-admin-course
kubectl apply -f online-boutique.yaml
}

f_admin_create_single_student_objects_labs9()
{
### Have to create the healthcheck beforehand
echo "Creating Health check for Origin Pool for $1 ..."
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$1/healthchecks" -d '{"metadata":{"name":"'$1'-hc"},"spec":{"healthy_threshold":3,"http_health_check":{"expected_status_codes":["200"],"path":"/"},"interval":15,"timeout":3,"jitter_percent":30,"unhealthy_threshold":1}}' | jq
sleep 1
s_op="$1-op"
echo "Creating Origin Pool for $1 ..."
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$1/origin_pools" -d '{"metadata":{"name":"'$s_op'"},"spec":{"origin_servers":[{"k8s_service":{"service_name":"boutique-frontend.'$1'","site_locator":{"virtual_site":{"tenant":"'$v_tenant'","namespace":"shared","name":"'$1'-vsite"}},"vk8s_networks":{}},"labels":{}}],"no_tls":{},"port":80,"same_as_endpoint_port":{},"healthcheck":[{"tenant":"'$v_tenant'","namespace":"'$1'","name":"'$1'-hc"}],"loadbalancer_algorithm":"LB_OVERRIDE","endpoint_selection":"LOCAL_PREFERRED","advanced_options":null}}'
}

f_admin_create_single_student_objects_labs10()
{
s_op="$1-op"
s_lb="$1-https-lb"
s_dom="$1.$v_dom"
echo "Creating HTTP Load Balancer for $1 ..."
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$1/http_loadbalancers" -d '{"metadata":{"name":"'$s_lb'"},"spec":{"domains":["'$s_dom'"],"https_auto_cert":{"http_redirect":true,"add_hsts":true,"tls_config":{"default_security":{}},"no_mtls":{},"default_header":{},"enable_path_normalize":{},"port":443,"non_default_loadbalancer":{},"header_transformation_type":{"default_header_transformation":{}},"connection_idle_timeout": 120000,"http_protocol_options":{"http_protocol_enable_v1_v2":{}}},"advertise_on_public_default_vip":{},"default_route_pools":[{"pool":{"tenant":"'$v_tenant'","namespace":"'$1'","name":"'$s_op'"},"weight":1,"priority":1,"endpoint_subsets":{}}],"origin_server_subset_rule_list":null,"disable_waf":{},"add_location":true,"no_challenge":{},"more_option":null,"user_id_client_ip":{},"disable_rate_limit":{},"malicious_user_mitigation":null,"waf_exclusion_rules":[],"data_guard_rules":[],"blocked_clients":[],"trusted_clients":[],"api_protection_rules":null,"ddos_mitigation_rules":[],"service_policies_from_namespace":{},"round_robin":{},"disable_trust_client_ip_headers":{},"disable_ddos_detection":{},"disable_malicious_user_detection":{},"disable_api_discovery":{},"disable_bot_defense":{},"disable_api_definition":{},"disable_ip_reputation":{},"disable_client_side_defense":{},"csrf_policy":null,"graphql_rules":[],"protected_cookies":[],"host_name":"","dns_info":[],"dns_records":[],"state_start_time":null}}'
sleep 1
echo ""
echo "Now make a browser connection to http://$1.f5training2.cloud"
echo ""
echo "It will take several minutes for the load balancer to be provisioned and active in F5XC"
echo ""
}

f_admin_create_single_student_objects_labs11()
{
s_lb="$1-https-lb"
s_dom="$1.$v_dom"
s_op="$1-op"
s_waf="$1-waf"
echo "Creating WAF Policy for $1 ..."
echo ""
echo "Added the word Hey at the start of the blocking page message ..."
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$1/app_firewalls" -d '{"metadata":{"name":"'$s_waf'","namespace":"'$1'"},"spec":{"blocking":{},"default_detection_settings":{},"default_bot_setting":{},"allow_all_response_codes":{},"default_anonymization":{},"blocking_page":{"blocking_page":"string:///PGh0bWw+PGhlYWQ+PHRpdGxlPlJlcXVlc3QgUmVqZWN0ZWQ8L3RpdGxlPjwvaGVhZD48Ym9keT5IZXkgVGhlIHJlcXVlc3RlZCBVUkwgd2FzIHJlamVjdGVkLiBQbGVhc2UgY29uc3VsdCB3aXRoIHlvdXIgYWRtaW5pc3RyYXRvci48YnIvPjxici8+WW91ciBzdXBwb3J0IElEIGlzOiB7e3JlcXVlc3RfaWR9fTxici8+PGJyLz48YSBocmVmPSJqYXZhc2NyaXB0Omhpc3RvcnkuYmFjaygpIj5bR28gQmFja108L2E+PC9ib2R5PjwvaHRtbD4=","response_code":"OK"}}}'
sleep 1
echo ""
echo "Adding the WAF Policy for $1 to the $s_lb load balancer ..."
echo ""
### echo "Current listing ..."
### curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/$1/http_loadbalancers/$s_lb"
curl -s -H "Authorization: APIToken $v_token" -X PUT "$v_url/config/namespaces/$1/http_loadbalancers/$s_lb" -d '{"metadata":{"name":"'$s_lb'","namespace":"'$1'"},"spec":{"domains":["'$s_dom'"],"https_auto_cert":{"http_redirect":true,"add_hsts":true,"tls_config":{"default_security":{}}},"default_route_pools":[{"pool":{"tenant":"'$v_tenant'","namespace":"'$1'","name":"'$s_op'"},"weight":1,"priority":1,"endpoint_subsets":{}}],"app_firewall":{"name":"'$s_waf'","namespace":"'$1'"}}}'
echo ""
echo "Now make a connection to https://$1.f5training2.cloud/test.exe"
echo ""
}

f_admin_create_single_student_objects_labs14()
{
s_wl="$1-workload"
s_container="$1-container"
s_image="public.ecr.aws/o2z6z0t3/juice-shop"
s_vol="$1-volume"
s_vsite1="$1-vsite"
s_dom="$1-workload.$v_dom"
echo "Creating vK8s workload for $1 ..."
echo ""
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$1/workloads" -d '{"metadata":{"name":"'$s_wl'","namespace":"'$1'","labels":{},"annotations":{},"description":"","disable":false},"spec":{"service":{"num_replicas":1,"containers":[{"name":"'$s_container'","image":{"name":"'$s_image'","public":{},"pull_policy":"IMAGE_PULL_POLICY_DEFAULT"},"init_container":false,"flavor":"CONTAINER_FLAVOR_TYPE_TINY","liveness_check":null,"readiness_check":null,"command":[],"args":[]}],"volumes":[{"name":"'$s_vol'","empty_dir":{"size_limit":4,"mount":{"mode":"VOLUME_MOUNT_READ_WRITE","mount_path":"/data","sub_path":""}}}],"configuration":null,"deploy_options":{"deploy_ce_virtual_sites":{"virtual_site":[{"tenant":"'$v_tenant'","namespace":"shared","name":"'$s_vsite1'"}]}},"advertise_options":{"advertise_on_public":{"port":{"port":{"info":{"port":3000,"protocol":"PROTOCOL_TCP","same_as_port":{}}},"http_loadbalancer":{"domains":["'$s_dom'"],"https_auto_cert":{"http_redirect":true,"add_hsts":true,"tls_config":{"default_security":{}},"no_mtls":{},"default_header":{},"enable_path_normalize":{},"port":443,"non_default_loadbalancer":{},"header_transformation_type":{"legacy_header_transformation":{}},"connection_idle_timeout":120000,"http_protocol_options":{"http_protocol_enable_v1_v2":{}},"coalescing_options":{"default_coalescing":{}}},"default_route":{"auto_host_rewrite":{}}}}}},"family":{"v4":{}}}}}'
sleep 1
echo ""
echo "Now make a browser connection to http://$1-workload.f5training2.cloud"
echo ""
echo "It will take several minutes for the load balancer to be provisioned and active in F5XC"
echo ""
}

f_admin_create_all_student_labs()
{
f_echo "Creating ADMIN labs 2-4 objects for $1 ..."
f_admin_create_single_student_objects_labs234 $1
f_dots 30
f_echo "Applying ADMIN lab 4 AWS VPC site objects for $1..."
f_admin_apply_single_student_objects_labs4 $1
f_dots 300
f_echo "Creating ADMIN lab 7 vK8s object, downloading Kubeconfig file for $1, and deploying application ..."
f_admin_create_single_student_kubeconfig_lab7 $1
f_dots 120
f_echo "Creating ADMIN lab 9 objects for $1 ..."
f_admin_create_single_student_objects_labs9 $1
f_dots 20
f_echo "Creating ADMIN lab 10 objects for $1 ..."
f_admin_create_single_student_objects_labs10 $1
f_dots 120
f_echo "Creating ADMIN lab 11 objects for $1 ..."
f_admin_create_single_student_objects_labs11 $1
f_dots 30
f_echo "Creating ADMIN lab 14 objects for $1 ..."
f_admin_create_single_student_objects_labs14 $1
f_dots 120
}

f_admin_create_all_12_student_labs()
{
echo "To be built ..."
exit 0
echo "Creating ADMIN class labs for all 12 students ..."
for count in {201..212}
do
 echo "Creating ADMIN class labs for student$count ..."
 f_admin_create_all_student_labs student$count
 f_dots 740
 echo "Done ..."
done
}

f_admin_list_deployments()
{
echo "Listing DNS Domain..."
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/system/dns_domains?report_fields" | jq
echo "List Deployments per student vK8s object..."
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/vk8s/namespaces/$1/$1-vk8s/apis/apps/v1/deployments" | jq
echo "Listing student endpoints ..."
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/$1/endpoints?report_fields" | jq
echo "Listing a specific endpoint ... service discovery is done through the k8s origin pool name"
k8s_objects_list="$(curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/$1/endpoints?report_fields" | jq -r .[][].name | grep $1-k8s)"
for k8s_name in ${k8s_objects_list[@]}; do
 echo $k8s_objects_list
 curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/$1/endpoints/$k8s_name" | jq
done
echo "List AWS VPC Sites ..."
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/system/aws_vpc_sites" | jq
echo "Get AWS VPC Site ..."
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/system/aws_vpc_sites/$1-vpc" | jq
echo "List K8s Cluster ..."
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/$1/k8s_clusters" | jq
}

f_waap_delete_single_student_objects()
{
### Only need to delete student namespace to delete all objects
### If only delete the HTTP load balancer it removs half of the objects as well
### except when XC puts objects into shared space like App Firewalls sometimes and they are not deleted
echo "Deleting namespace ..."
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/web/namespaces/$1/cascade_delete" | jq
sleep 2
echo "Revoking API credentials ..."
apicreds_list="$(curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/web/namespaces/system/api_credentials" | jq -r .[][].name | grep -E $1)"
for apicred_name in ${apicreds_list[@]}; do
 curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/web/namespaces/system/revoke/api_credentials" -d '{"name":"'$apicred_name'"}' | jq
done
echo "Run the -lso option again to check for object outliers and manually delete them ..."
}

f_waap_delete_all_student_objects()
{
for ((i=1; i<=12; i++))
do
 echo "Deleting all WAAP objects for $i ..."
 ### It picks up both single and multiple numbers in the student name listing just ignore
 curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/web/namespaces" | jq -r .[][].name | grep -E student$i
 sleep 1
 curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/web/namespaces/student$i/cascade_delete" | jq
 sleep 1
 echo "Revoking API credentials ..."
 apicreds_list="$(curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/web/namespaces/system/api_credentials" | jq -r .[][].name | grep -E $1 )"
 for apicred_name in ${apicreds_list[@]}; do
  curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/web/namespaces/system/revoke/api_credentials" -d '{"name":"'$apicred_name'"}' | jq
 done
done
echo "Run the -lso and -walst options again to check for object outliers and manually delete them ..."
}

f_waap_list_single_student_objects()
{
### List labs 1-3 per student
echo "Namespaces for $1 ..."
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/web/namespaces" | jq -r .[][].name | grep -E "$1"
sleep 2
echo "HTTP load balancers ..."
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/$1/http_loadbalancers?report_fields" | jq
sleep 2
echo "Origin pools ..."
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/$1/origin_pools/$1-juice-op?report_fields" | jq
sleep 2
echo "Health checks ..."
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/$1/healthchecks?report_fields" | jq
sleep 2
echo "API credentials ..."
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/web/namespaces/system/api_credentials" | jq -r .[][].name | grep -E $1
}

f_waap_create_single_student_objects()
{
### Create labs 1-3 for a student
### Create the port number for the origin pool range is 1001 to 1012
### Tenant matters for JuiceShop check which tenant environment we are using
### WAAP Lab 3 uses studentX-juice.f5training2.cloud
fqdn="$1-juice.f5training2.cloud"
s_juice_ip="34.197.42.60"
snumdigits=`echo $1 | wc -m`
if [ $snumdigits -eq 11 ]; then
 snum=`echo -n $1 | tail -c 2`
 pnum="10$snum"
fi
echo "Creating Namespace for $1 ..."
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/web/namespaces" -d '{"metadata":{"name":"'$1'"},"spec":{}}' | jq
sleep 1
### have to create OP, Origin server, health check beforehand and reference in load balancer
echo "Creating Health check for HTTP Load Balancer for $1 ..."
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$1/healthchecks" -d '{"metadata":{"name":"'$1'-juice-hc"},"spec":{"healthy_threshold":3,"http_health_check":{"expected_status_codes":["200"],"path":"/"},"interval":15,"timeout":3,"jitter_percent":30,"unhealthy_threshold":1}}' | jq
sleep 1
echo "Creating Origin Pool and Origin Server for HTTP Load Balancer for $1 ..."
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$1/origin_pools" -d '{"metadata":{"name":"'$1'-juice-op"},"spec":{"gc_spec":{},"origin_servers":[{"public_ip":{"ip":"'$s_juice_ip'"},"labels":{}}],"port":"'$pnum'","healthcheck":[{"namespace":"'$1'","name":"'$1'-juice-hc"}]}}' | jq
sleep 1
echo "Creating HTTP Load Balancer for $1 ..."
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$1/http_loadbalancers" -d '{ "metadata":{"name":"'$1'-juice-lb","namespace":"'$1'"},"spec":{"domains":["'$fqdn'"],"https_auto_cert":{"add_hsts":true,"http_redirect":true},"port":"443","default_route_pools":[{"pool":{"namespace":"'$1'","name":"'$1'-juice-op"},"weight":"1","priority":"1"}],"add_location":true,"enable_api_discovery":{"enable_learn_from_redirect_traffic":{},"discovered_api_settings":{"purge_duration_for_inactive_discovered_apis":2}}} }' | jq
}

f_test()
{
echo "Listing API credentials ..."
### curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/web/namespaces/system/api_credentials" | jq -r .[][].name | grep -E 'student[1-9]{1}'
sleep 1
### curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/web/namespaces/system/api_credentials" | jq -r .[][].name | grep -E $1
echo "Listing students endpoints ..."
### curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/student14/endpoints?report_fields" | jq
echo "Listing a specific endpoint ..."
### curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/student14/endpoints/ves-io-origin-pool-student14-k8s-57455d94bf" | jq
echo "Listing vK8s structures ..."
### curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/student14/virtual_k8ss" | jq
echo "Listing a specific vK8s structure ..."
### curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/student14/virtual_k8ss/student14-vk8s" | jq
echo "Listing Virtual Networks ..."
### curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/student14/virtual_networks" | jq
echo "Listing specific Virtual Network ..."
### curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/shared/virtual_networks/public" | jq
echo "Get Internal View of Object ..."
### curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/student14/view_internal/aws_vpc_site/student14-vpc" | jq
### curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/student14/view_internal/aws_vpc_site/view1" | jq
echo "Listing Namespace Discoverys ..."
### curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/$1/discoverys" | jq
### curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/system/discoverys" | jq
}

### main

f_echo "F5 Training $product_name script Version $script_ver"

if [ $# -eq 0 ]; then
f_usage
fi

f_log start
while [ $# -gt 0 ]; do
 case "$1" in
   -test)
   if [ "$#" != 2 ]; then
    f_echo "Missing student name ... "
    exit 1
   fi
   f_echo "Testing with $2 ..."
   f_test $2
   ;;
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
   -addso)
   if [ "$#" != 2 ]; then
    f_echo "Missing student name ... "
    exit 1
   fi
   f_echo "Deleting $2 objects ..."
   f_delete_single_student_objects $2
   ;;
   -addas)
   echo ""
   echo "This option will remove all objects for students 1 to 12 for the admin course"
   echo "You may prefer to use the -addso option and check results per student as you go along"
   echo ""
   read -p "Are you sure you wish to continue (y/n) ?" choice
   if [ "$choice" = "y" ]; then
    f_echo "Deleting objects for students (1-12, 101-112, 201-212) ..."
    f_delete_all_student_objects
   else
    echo "Exiting ..."
    exit 0
   fi
   ;;
   -adlst)
   if [ "$#" != 2 ]; then
    f_echo "Missing student name ... "
    exit 1
   fi
   f_echo "Listing AWS VPC site for $2 ..."
   f_admin_list_single_student_aws_vpc $2
   ;;
   -adcre23)
   if [ "$#" != 2 ]; then
    f_echo "Missing student name ... "
    exit 1
   fi
   f_echo "Creating ADMIN labs 2-3 objects for $2 ..."
   f_admin_create_single_student_objects_labs23 $2
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
   if [ "$#" != 2 ]; then
    f_echo "Missing student name ... "
    exit 1
   fi
   f_echo "Creating ADMIN lab 7 objects for $2 ..."
   f_admin_create_single_student_objects_labs7 $2
   ;;
   -adkub7)
   if [ "$#" != 2 ]; then
    f_echo "Missing student name ... "
    exit 1
   fi
   f_echo "Creating ADMIN lab 7 vK8s object, downloading Kubeconfig file for $2, and deploying application ..."
   f_admin_create_single_student_kubeconfig_lab7 $2
   ;;
   -adcre9)
   if [ "$#" != 2 ]; then
    f_echo "Missing student name ... "
    exit 1
   fi
   f_echo "Creating ADMIN lab 9 objects for $2 ..."
   f_admin_create_single_student_objects_labs9 $2
   ;;
   -adcre10)
   if [ "$#" != 2 ]; then
    f_echo "Missing student name ... "
    exit 1
   fi
   f_echo "Creating ADMIN lab 10 objects for $2 ..."
   f_admin_create_single_student_objects_labs10 $2
   ;;
   -adcre11)
   if [ "$#" != 2 ]; then
    f_echo "Missing student name ... "
    exit 1
   fi
   f_echo "Creating ADMIN lab 11 objects for $2 ..."
   f_admin_create_single_student_objects_labs11 $2
   ;;
   -adcre14)
   if [ "$#" != 2 ]; then
    f_echo "Missing student name ... "
    exit 1
   fi
   f_echo "Creating ADMIN lab 14 objects for $2 ..."
   f_admin_create_single_student_objects_labs14 $2
   ;;
   -adcreall)
   if [ "$#" != 2 ]; then
    f_echo "Missing student name ... "
    exit 1
   fi
   echo ""
   echo "This option will create all the labs for the ADMIN class for $2. It takes some time (12 mins)"
   echo ""
   read -p "Are you sure you wish to continue (y/n) ?" choice
   if [ "$choice" = "y" ]; then
    f_echo "Creating all ADMIN labs for $1 ..."
    f_admin_create_all_student_labs $2
   else
    echo "Exiting ..."
    exit 0
   fi
   ;;
   -adcreall12)
   echo ""
   echo "This option will create all the labs for the ADMIN class for all 12 students"
   echo "It will take some time"
   echo ""
   read -p "Are you sure you wish to continue (y/n) ?" choice
   if [ "$choice" = "y" ]; then
    f_echo "Creating all the ADMIN labs for 12 students. This will take some time ..."
    f_admin_create_all_12_student_labs
   else
    echo "Exiting ..."
    exit 0
   fi
   ;;
   -wadso)
   if [ "$#" != 2 ]; then
    f_echo "Missing student name ... "
    exit 1
   fi
   f_echo "Deleting all WAAP objects for $2 ..."
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
   -adlstd)
   if [ "$#" != 2 ]; then
    f_echo "Missing student name ... "
    exit 1
   fi
   f_echo "Listing Deployments for $2 ..."
   f_admin_list_deployments $2
   ;;
   *)
   ;;
 esac
 shift
done
f_log end
f_echo "End ..."
