#!/bin/bash

### variables

product_name="F5 Distributed Cloud"
script_ver="1.0"
script_name="cet.sh"
student_name=$2

### Points to classroom 1
v_token="TREqu7Yp55Pfvon+MmLXpavWV7uAYXw="
v_url="https://training.console.ves.volterra.io/api"
v_tenant="training-ytfhxsmw"
v_dom="aws.learnf5.cloud"
v_aws_creds_name="learnf5-aws"

### functions

f_echo()
{
echo -e $1
}

f_usage()
{
echo "Script to tunnel into CE"
echo ""
echo "Usage: ./${script_name} -option"
echo ""
echo "Options:"
echo ""
echo "-tok                                              Test token"
echo "-lcs                                              List all cloud sites"
echo "-las <studentname>                                List a cloud site"
echo "-adcreop <studentname> <Private DNS Name IPv4>    ADMIN - Create Origin Pool"
echo "-adcrelb <studentname>                            ADMIN - Create TCP Load Balancer"
echo ""
echo "Prerequisites:"
echo ""
echo "Namespace, key pair, virtual site, and cloud site for AWS must be created for the user"
echo ""
echo "Then run (replace X with your student number):"
echo "cd /home/student"
echo "ping studentX.aws.learnf5.cloud"
echo "ssh -p 200X -i .ssh/id_rsa cloud-user@studentX.aws.learnf5.cloud"
echo ""
echo "ssh -p 200X -i .ssh/id_rsa cloud-user@studentX.dev.learnf5.cloud"
echo ""
exit 0
}

f_test_token()
{
curl -s -X GET -H "Authorization: APIToken $v_token" $v_url/web/namespaces | jq
}

f_list_all_cloud_sites()
{
echo "All AWS VPC cloud sites ..."
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/system/aws_vpc_sites" | jq
}

f_list_student_cloud_sites()
{
echo "All AWS VPC cloud sites for $2 ..."
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/system/aws_vpc_sites" | jq -r .[][].name | grep -E $1
}

f_admin_create_single_student_objects_tcp_op()
{
s_tcp_op="$1-tcp"
s_ipdns_name="$2"
echo "Creating Origin Pool for $1 ..."
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$1/origin_pools" -d '{"metadata":{"name":"'$s_tcp_op'","namespace":"shared"},"spec":{"origin_servers":[{"private_name":{"dns_name":"'$s_ipdns_name'","site_locator":{"virtual_site":{"tenant":"'$v_tenant'","name":"'$1'-vsite","namespace":"shared"}},"outside_network":{}},"labels":{}}],"port":22,"same_as_endpoint_port":{},"healthcheck":[],"loadbalancer_algorithm":"LB_OVERRIDE","endpoint_selection":"LOCAL_PREFERRED","advanced_options":null}}}'
}

f_admin_create_single_student_objects_tcp_lb()
{
singleordouble=`echo $1 | wc -m`
if [ $singleordouble -eq 10 ]; then
 snum=`echo -n $1 | tail -c 2`
 pnum="20$snum"
else
 snum=`echo -n $1 | tail -c 1`
 pnum="200$snum"
fi
s_tcp_op="$1-tcp"
s_tcp_lb="$1-tcp-lb"
s_dom="$1.$v_dom"
echo "Creating TCP Load Balancer for $1 ..."
### curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/$1/tcp_loadbalancers/student$snum-tcp-lb?report_fields" | jq
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$1/tcp_loadbalancers" -d '{"metadata":{"name":"'$s_tcp_lb'"},"spec":{"domains":["'$s_dom'"],"listen_port":'$pnum',"no_sni":{},"dns_volterra_managed":true,"origin_pools":[],"origin_pools_weights":[{"pool":{"tenant":"'$v_tenant'","namespace":"'$1'","name":"'$s_tcp_op'"},"weight":1,"priority":1,"endpoint_subsets":{}}],"advertise_on_public_default_vip":{},"hash_policy_choice_round_robin":{},"idle_timeout":3600000,"retract_cluster":{},"tcp":{},"service_policies_from_namespace":{},"auto_cert_info":{"auto_cert_state":"AutoCertDisabled","auto_cert_expiry":null,"auto_cert_subject":"","auto_cert_issuer":"","dns_records":[],"state_start_time":null}}}'
}

### main

f_echo "F5 Training $product_name script Version $script_ver"

if [ $# -eq 0 ]; then
f_usage
fi

while [ $# -gt 0 ]; do
 case "$1" in
   -test)
   if [ "$#" != 2 ]; then
    f_echo "Missing student name ... "
    exit 1
   fi
   f_echo "testing with $2 ..."
   f_test $2
   ;;
   -tok)
   f_test_token
   ;;
   -lcs)
   f_echo "Listing all cloud sites"
   f_list_all_cloud_sites
   ;;
    -las)
   if [ "$#" != 2 ]; then
    f_echo "Missing student name ... "
    exit 1
   fi
   f_echo "Listing cloud sites for $2..."
   f_list_student_cloud_sites $2
   ;;
   -adcreop)
   if [ "$#" != 3 ]; then
    f_echo "Either missing student name or private IP DNS name ... "
    exit 1
   fi
   echo Student name: $2
   echo IP DNS name: $3
   f_echo "Creating origin pool object for $2 ..."
   f_admin_create_single_student_objects_tcp_op $2 $3
   ;;
   -adcrelb)
   if [ "$#" != 2 ]; then
    f_echo "Missing student name ... "
    exit 1
   fi
   f_echo "Creating TCP load balancer object for $2 ..."
   f_admin_create_single_student_objects_tcp_lb $2
   ;;
   *)
   ;;
 esac
 shift
done
f_echo "End ..."
