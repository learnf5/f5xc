#!/bin/bash

### variables

product_name="F5 Distributed Cloud"
script_ver="1.0"
script_name="mc.sh"
student_name=$2

### This script is built to handle both production and development sites
### Comment out variables to switch between them

### Points to the Training Development F5XC console which points to AWS and Azure
v_token="CfxhI08CzaktknCrXwsrCmOPibI="
v_url="https://training-dev.console.ves.volterra.io/api"
v_tenant="training-dev-fcphvhww"
v_dom="dev.learnf5.cloud"
v_aws_creds_name="learnf5-aws"
v_azu_creds_name="all-students-credentials"

### Points to classroom 1 - the First Public Training F5XC console which points to the Training AWS instance
### v_token="u7Yp55Pfvon+MmLXpavWV7uAYXw="
### v_url="https://training.console.ves.volterra.io/api"
### v_tenant="training-ytfhxsmw"
### v_dom="aws.learnf5.cloud"
### AWS creds inside Multi-Cloud Network Connect > Manage > Site Management > Cloud Credentials > Cloud Sites
## v_aws_creds_name="learnf5-aws"

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
echo "-mccns <studentname>       MC - Create namespace"
echo "-mcckl <studentname>       MC - Create key, label"
echo "-mccvsaws <studentname>    MC - Create virtual site - AWS"
echo "-mcclsaws <studentname>    MC - Create cloud site - AWS"
echo "-mcappaws <studentname>    MC - Apply cloud site - AWS"
echo "-mccvsazu <studentname>    MC - Create virtual site - Azure"
echo "-mcclsazu <studentname>    MC - Create cloud site - Azure"
echo "-mcappazu <studentname>    MC - Apply cloud site - Azure"
echo ""
echo "-mclso <studentname>       MC - List student objects"
echo "-mcdso <studentname>       MC - Delete student objects"
echo ""
echo "Prerequisites:"
echo ""
echo "1 - The API token must work, they expire, run the -tok option to check still valid"
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

f_mc_create_single_student_namespace()
{
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
}

f_mc_create_single_student_kl()
{
singleordouble=`echo $1 | wc -m`
if [ $singleordouble -eq 10 ]; then
 snum=`echo -n $1 | tail -c 2`
 pnum="10$snum"
else
 snum=`echo -n $1 | tail -c 1`
 pnum="100$snum"
fi
s_key="$1-key"
s_value="$1-value"
echo "Creating key label for $1 ..."
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/shared/known_label_key/create" -d '{"key":"'$s_key'","namespace":"'$1'"}'
sleep 1
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/shared/known_label/create" -d '{"key":"'$s_key'","namespace":"'$1'","value":"'$s_value'"}'
}

f_mc_create_single_student_vsaws()
{
singleordouble=`echo $1 | wc -m`
if [ $singleordouble -eq 10 ]; then
 snum=`echo -n $1 | tail -c 2`
 pnum="10$snum"
else
 snum=`echo -n $1 | tail -c 1`
 pnum="100$snum"
fi
s_key="$1-key"
s_value="$1-value"
s_vsite_name="$1-vsite"
s_aws_vpc_name="$1-vpc"
echo "Creating Virtual Site of type CE for AWS for $1 ..."
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/shared/virtual_sites" -d '{"metadata":{"name":"'$s_vsite_name'","namespace":"'$1'"},"spec":{"site_selector":{"expressions":["'$s_key' in ('$s_value')"]},"site_type":"CUSTOMER_EDGE"}}'
}

f_mc_create_single_student_vsazu()
{
singleordouble=`echo $1 | wc -m`
if [ $singleordouble -eq 10 ]; then
 snum=`echo -n $1 | tail -c 2`
 pnum="10$snum"
else
 snum=`echo -n $1 | tail -c 1`
 pnum="100$snum"
fi
s_key="$1-key"
s_value="$1-value"
s_vsite_name="$1-vsite"
s_aws_vpc_name="$1-vpc"
echo "Creating Virtual Site of type CE for Azure for $1 ..."
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/shared/virtual_sites" -d '{"metadata":{"name":"'$s_vsite_name'","namespace":"'$1'"},"spec":{"site_selector":{"expressions":["'$s_key' in ('$s_value')"]},"site_type":"CUSTOMER_EDGE"}}'
}

f_mc_create_single_student_clsaws()
{
singleordouble=`echo $1 | wc -m`
if [ $singleordouble -eq 10 ]; then
 snum=`echo -n $1 | tail -c 2`
 pnum="10$snum"
else
 snum=`echo -n $1 | tail -c 1`
 pnum="100$snum"
fi
s_key="$1-key"
s_value="$1-value"
s_vsite_name="$1-vsite"
s_aws_vpc_name="$1-vpc"
echo "Creating AWS VPC site configuration for $1 ..."
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/system/aws_vpc_sites" -d '{"metadata":{"name":"'$s_aws_vpc_name'","namespace":"system","labels":{"'$s_key'":"'$s_value'"}},"spec":{"vpc":{"new_vpc":{"autogenerate":{},"primary_ipv4":"172.31.0.0/16","allocate_ipv6":false}},"ingress_gw":{"az_nodes":[{"aws_az_name":"us-east-1a","local_subnet":{"subnet_param":{"ipv4":"172.31.'$snum'.0/24"}},"disk_size":0}],"aws_certified_hw":"aws-byol-voltmesh","allowed_vip_port":{"use_http_https_port":{}},"performance_enhancement_mode":{"perf_mode_l7_enhanced":{}}},"aws_cred":{"tenant":"'$v_tenant'","namespace":"system","name":"'$v_aws_creds_name'"},"instance_type":"m5.4xlarge","disk_size":0,"volterra_software_version":"","operating_system_version":"","aws_region":"us-east-1","ssh_key":"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDc+HSquvm6Bbvnk4h2KMR51MwnzBPWzbmhK5tiW8sC4rh+VzrcjNgnrc4Op7tFtLkv2sq/Vecg9QB6jMamGoBrqWP3qjejSxYWwr8xP/ZNRlqJNwGxEAQlDkUkKtUfNWgmOZtoVq249vvewyUCbmOlpgFDPPeNGfQrutJkOHmUj53kEIhhkoE+ZieY2Ls5fHTNgUDznf8KysnrIAr+reEKt7FREL+4kKnCp9ZlZtw/nw5sSDFNU9PRZuTwZIE85oY9nDxe9fRRttBSMHq9g0GD0iZg9fjafuB0Ft7qzkSq20vGrtYxfGgPW8kIjZBA95CSyA2gRsnSxUF7Fq+W50EWZfqU4O9KOZwKo8dTcbjmS+S5S5avK37uVn1v99rdG3Z9xbfBW8tohARDGlzC1R1Qh+LrfPgjds7oKXewT6hiHDe0wsMp25IxYUGEHqdEaAs4Bfos4Qw2Lwhjc2brNAO1aD9VpQPf9RMkv+gEDLoWdLEHw+qpRInDcO1N3kt8bQM= student@PC01","address":"","logs_streaming_disabled":{},"vip_params_per_az":[],"no_worker_nodes": {},"default_blocked_services":{},"direct_connect_disabled":{},"offline_survivability_mode":{"no_offline_survivability_mode":{}},"enable_internet_vip":{},"egress_gateway_default":{},"suggested_action":"","error_description":"", "f5xc_security_group":{},"direct_connect_info":null}}'
}

f_mc_apply_single_student_objects_clsaws()
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
echo "Applying Terraform Plan for AWS VPC Site configuration for $1 ..."
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/terraform/namespaces/system/terraform/aws_vpc_site/$s_aws_vpc_name/run" -d '{"action":"APPLY"}'
echo ""
echo "Check the GUI for the green Apply button and check AWS. Process takes some minutes to run ..."
}

f_mc_create_single_student_clsazu()
{
singleordouble=`echo $1 | wc -m`
if [ $singleordouble -eq 10 ]; then
 snum=`echo -n $1 | tail -c 2`
 pnum="10$snum"
else
 snum=`echo -n $1 | tail -c 1`
 pnum="100$snum"
fi
s_key="$1-key"
s_value="$1-value"
s_vsite_name="$1-vsite"
s_azu_vnet_name="$1-vnet"
s_azu_rg="$1-rg"
echo "Creating Azure VNET site configuration for $1 ..."
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/system/azure_vnet_sites" -d '{"metadata":{"name":"'$s_azu_vnet_name'","namespace":"system","labels":{"'$s_key'":"'$s_value'"}},"spec":{"resource_group": "'$s_azu_rg'","vnet":{"new_vnet":{"autogenerate":{},"primary_ipv4":"172.31.0.0/16","allocate_ipv6":false}},"ingress_gw":{"az_nodes":[{"azure_az":"1","local_subnet":{"subnet_param":{"ipv4":"172.31.'$snum'.0/24"}},"disk_size":0}],"azure_certified_hw":"azure-byol-voltmesh","allowed_vip_port":{"use_http_https_port":{}},"performance_enhancement_mode":{"perf_mode_l7_enhanced":{}}},"azure_cred":{"tenant":"'$v_tenant'","namespace":"system","name":"'$v_azu_creds_name'"},"machine_type":"Standard_D3_v2","disk_size":0,"volterra_software_version":"","operating_system_version":"","azure_region":"eastus","ssh_key":"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDc+HSquvm6Bbvnk4h2KMR51MwnzBPWzbmhK5tiW8sC4rh+VzrcjNgnrc4Op7tFtLkv2sq/Vecg9QB6jMamGoBrqWP3qjejSxYWwr8xP/ZNRlqJNwGxEAQlDkUkKtUfNWgmOZtoVq249vvewyUCbmOlpgFDPPeNGfQrutJkOHmUj53kEIhhkoE+ZieY2Ls5fHTNgUDznf8KysnrIAr+reEKt7FREL+4kKnCp9ZlZtw/nw5sSDFNU9PRZuTwZIE85oY9nDxe9fRRttBSMHq9g0GD0iZg9fjafuB0Ft7qzkSq20vGrtYxfGgPW8kIjZBA95CSyA2gRsnSxUF7Fq+W50EWZfqU4O9KOZwKo8dTcbjmS+S5S5avK37uVn1v99rdG3Z9xbfBW8tohARDGlzC1R1Qh+LrfPgjds7oKXewT6hiHDe0wsMp25IxYUGEHqdEaAs4Bfos4Qw2Lwhjc2brNAO1aD9VpQPf9RMkv+gEDLoWdLEHw+qpRInDcO1N3kt8bQM= student@PC01","address":"","logs_streaming_disabled":{},"vip_params_per_az":[],"no_worker_nodes": {},"default_blocked_services":{},"direct_connect_disabled":{},"offline_survivability_mode":{"no_offline_survivability_mode":{}},"enable_internet_vip":{},"egress_gateway_default":{},"suggested_action":"","error_description":"", "f5xc_security_group":{},"direct_connect_info":null}}'
}

f_mc_apply_single_student_objects_clsazu()
{
singleordouble=`echo $1 | wc -m`
if [ $singleordouble -eq 10 ]; then
 snum=`echo -n $1 | tail -c 2`
 pnum="10$snum"
else
 snum=`echo -n $1 | tail -c 1`
 pnum="100$snum"
fi
s_azu_vnet_name="$1-vnet"
echo "Applying Terraform Plan for Azure VNET Site configuration for $1 ..."
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/terraform/namespaces/system/terraform/azure_vnet_site/$s_azu_vnet_name/run" -d '{"action":"APPLY"}'
echo ""
echo "Check the GUI for the green Apply button and check Azure. Process takes some minutes to run ..."
}

f_mc_list_student_objects()
{
echo "Known label ..."
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/shared/known_labels?key=&namespace=shared&query=QUERY_ALL_LABELS&value=" | jq -r .label[].value | grep -E $1
echo "Known key ..."
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/shared/known_label_keys?key=&namespace=shared&query=QUERY_ALL_LABEL_KEYS" | jq -r .label_key[].key | grep -E $1
echo "AWS VPC cloud site ..."
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/system/aws_vpc_sites" | jq -r .[][].name | grep -E $1
echo "Azure VNET cloud site ..."
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/system/azure_vnet_sites" | jq -r .[][].name | grep "$1-vnet"
echo "Virtual site ..."
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/shared/virtual_sites" | jq -r .[][].name | grep -E $1
echo "Namespace ..."
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/web/namespaces" | jq -r .[][].name | grep $1
echo "End of object list ..."
echo ""
}

f_mc_delete_student_objects()
{
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
echo "Deleting namespace ..."
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/web/namespaces/$1/cascade_delete" | jq
echo "End of object list ..."
echo ""
echo "Any AWS or Azure cloud site objects needs to be deleted TWICE"
echo "The second deletes the F5XC object, so run"
echo "this option again after say 10 mins for the second delete"
echo ""
echo "OR . . ."
echo ""
echo "delete the student VPC or VNET objects via the GUI, probably quicker"
echo ""
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
   -mcdso)
   if [ "$#" != 2 ]; then
    f_echo "Missing student name ... "
    exit 1
   fi
   f_echo "Deleting $2 objects ..."
   f_mc_delete_single_student_objects $2
   ;;
   -mccns)
   if [ "$#" != 2 ]; then
    f_echo "Missing student name ... "
    exit 1
   fi
   f_echo "Creating namespace for $2 ..."
   f_mc_create_single_student_namespace $2
   ;;
   -mcckl)
   if [ "$#" != 2 ]; then
    f_echo "Missing student name ... "
    exit 1
   fi
   f_echo "Creating key label for $2 ..."
   f_mc_create_single_student_kl $2
   ;;
   -mccvsaws)
   if [ "$#" != 2 ]; then
    f_echo "Missing student name ... "
    exit 1
   fi
   f_echo "Creating virtual site for AWS for $2 ..."
   f_mc_create_single_student_vsaws $2
   ;;
   -mccvsazu)
   if [ "$#" != 2 ]; then
    f_echo "Missing student name ... "
    exit 1
   fi
   f_echo "Creating virtual site for Azure for $2 ..."
   f_mc_create_single_student_vsaws $2
   ;;
   -mcclsaws)
   if [ "$#" != 2 ]; then
    f_echo "Missing student name ... "
    exit 1
   fi
   f_echo "Creating cloud site AWS for $2 ..."
   f_mc_create_single_student_clsaws
   ;;
   -mcappaws)
   if [ "$#" != 2 ]; then
    f_echo "Missing student name ... "
    exit 1
   fi
   f_echo "Applying AWS cloud site for $2 ..."
   f_mc_apply_single_student_objects_clsaws $2
   ;;
   -mcclsazu)
   if [ "$#" != 2 ]; then
    f_echo "Missing student name ... "
    exit 1
   fi
   f_echo "Creating cloud site Azure for $2 ..."
   f_mc_create_single_student_clsazu $2
   ;;
   -mcappazu)
   if [ "$#" != 2 ]; then
    f_echo "Missing student name ... "
    exit 1
   fi
   f_echo "Applying Azure cloud site for $2 ..."
   f_mc_apply_single_student_objects_clsazu $2
   ;;
   -mclso)
   if [ "$#" != 2 ]; then
    f_echo "Missing student name ... "
    exit 1
   fi
   f_echo "Listing F5XC objects for $2 ..."
   f_mc_list_student_objects $2
   ;;
   -mcdso)
   if [ "$#" != 2 ]; then
    f_echo "Missing student name ... "
    exit 1
   fi
   f_echo "Deleting all F5XC objects for $2 ..."
   f_mc_delete_student_objects $2
   ;;
   *)
   ;;
 esac
 shift
done
f_echo "End ..."
