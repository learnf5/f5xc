#!/bin/bash

### variables

product_name="F5 Distributed Cloud"
script_ver="3.0"
script_name="class2.sh"
student_name=$2

v_token=""
v_url="https://training2.console.ves.volterra.io/api"
v_tenant="training1-rcfjmagj"
v_dom="f5training2.cloud"
v_logfile="$script_name.log"
v_aws_region="us-east-1"
v_aws_az="us-east-1a"
v_ce_ami_id="ami-000bc40f0b0d64b35"
v_instance_type="m5.2xlarge"
v_volume_size="80"
v_f5xc_api_url="$v_url"
v_certname="training2.console.ves.volterra.io.api-creds"
v_VES_P12_PASSWORD=""
v_awskeys_password=""
v_f5xc_ssh_key="sshkeys"
v_instructor_name="instructor2"

### ADMIN functions

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
echo ""
echo "-lab33                     ADMIN - Create Lab 3.3 all objects for $v_instructor_name"
echo "-lab63 <studentname>       ADMIN - Create Lab 6.3 all objects"
echo ""
echo "-cert <cert password>      ADMIN - Create and download F5XC API Certificate"
echo "-keys                      ADMIN - Retrieve AWS Keys"
echo "-a1 <keys password>        ADMIN - Encrypt AWS Keys - requires awskeys file"
echo "-a2                        ADMIN - Remove awskeys file"
echo "-a3 <keys password>        ADMIN - Create env file with cert and keys"
echo "-a4 <password>             ADMIN - Create student Terraform vars file"
echo ""
echo "-s1                        ADMIN - List current SMSv2 CEs"
echo "-s2 <studentname>          ADMIN - Create demo-smsv2-ce-aws2 CE object on XC"
echo ""
echo "-w1 <studentname>          WAAP - Create labs 1-3 student objects"
echo "-w2 <studentname>          WAAP - List first labs student objects"
echo "-w3 <studentname>          WAAP - Delete single student objects"
echo "-w4                        WAAP - Delete all student objects"
echo ""
echo ""
echo "Prerequisites:"
echo ""
echo "1 - Create your own F5XC API token to run this script. This must work, they expire,"
echo "    run the -tok option to check still valid"
echo "2 - Enter a password of 6 or more characters for the F5XC API Certificate password"
echo "2 - Create and load the AWS Keys into a file called awskeys"
echo "4 - Enter a password for the AWS keys"
echo "5 - Create an SSH key file called sshkeys"
echo ""
echo "Notes:"
echo ""
exit 0
}

f_test_token()
{
curl -s -X GET -H "Authorization: APIToken $v_token" $v_url/web/namespaces | jq
}

f_lab33()
{
echo "Creating Instructor namespace for $v_instructor_name ..."
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/web/namespaces" -d '{"metadata":{"name":"'$v_instructor_name'"},"spec":{}}' | jq
sleep 1
echo "Creating Health Check ..."
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$v_instructor_name/healthchecks" -d '{"metadata":{"name":"lab33-hc"},"spec":{"healthy_threshold":3,"http_health_check":{"expected_status_codes":["200"],"path":"/"},"interval":15,"timeout":3,"jitter_percent":30,"unhealthy_threshold":1}}' | jq
sleep 1
echo "Creating Origin Pool and Origin Server ..."
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$v_instructor_name/origin_pools" -d '{"metadata":{"name":"lab33-op"},"spec":{"gc_spec":{},"origin_servers":[{"public_ip":{"ip":"3.209.174.119"},"labels":{}}],"port":"80","healthcheck":[{"namespace":"'$v_instructor_name'","name":"lab33-hc"}]}}' | jq
sleep 1
echo "Creating HTTPS Load Balancer ..."
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$v_instructor_name/http_loadbalancers" -d '{ "metadata":{"name":"lab33-lb","namespace":"'$v_instructor_name'"},"spec":{"domains":["lab33.'$v_dom'"],"https_auto_cert":{"add_hsts":true,"http_redirect":true},"port":"443","default_route_pools":[{"pool":{"namespace":"'$v_instructor_name'","name":"lab33-op"},"weight":"1","priority":"1"}],"add_location":true,"enable_api_discovery":{"enable_learn_from_redirect_traffic":{},"discovered_api_settings":{"purge_duration_for_inactive_discovered_apis":2}}} }' | jq
}

f_lab63()
{
s_op="$1-ce-int-op"
s_ce_name="$1-smsv2-ce"
s_lb_name="$1-ce-int-lb"
s_domain="$s_lb_name.$v_dom"
echo ""
echo "It is assumed the namespace and the CE already exists for $1 ..."
echo ""
echo "Creating Origin Pool and Origin Server for $1 ..."
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$1/origin_pools" -d '{"metadata":{"name":"'$s_op'"},"spec":{"origin_servers":[{"private_ip":{"ip":"172.31.51.51","site_locator":{"site":{"namespace":"system","name":"'$s_ce_name'"}},"inside_network":{},"snat_pool":{}},"labels":{}}],"port":"80","healthcheck":[]}}' | jq
sleep 1
echo "Creating HTTPS Load Balancer for $1 ..."
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$1/http_loadbalancers" -d '{ "metadata":{"name":"'$s_lb_name'","namespace":"'$1'"},"spec":{"domains":["'$s_domain'"],"https_auto_cert":{"add_hsts":true,"http_redirect":true},"port":"443","default_route_pools":[{"pool":{"namespace":"'$1'","name":"'$s_op'"},"weight":"1","priority":"1"}],"add_location":true,"enable_api_discovery":{"enable_learn_from_redirect_traffic":{},"discovered_api_settings":{"purge_duration_for_inactive_discovered_apis":2}}} }' | jq
}

f_cert()
{
echo ""
echo "Creating and downloading API Certificate ..."
echo "The name of the certificate defaults to $v_certname ..."
curl -v -s -H "Authorization: APIToken $v_token" -X POST "$v_url/web/namespaces/system/api_credentials" -d '{"name":"apicert1","namespaces":"system","expiration_days":1,"spec":{"password":"'$v_VES_P12_PASSWORD'","type":"API_CERTIFICATE","name":"apicert1","namespace":"system"}}' 1>encoded_cert.yaml 2>certapi.error
echo "Takes a while ..."
sleep 2
echo "Decoding file ..."
cat encoded_cert.yaml | jq -r '.data' | base64 --decode 1>$v_certname.p12
sleep 1
cat $v_certname.p12
}

f_a1()
{
openssl enc -aes-256-cbc -salt -a -pbkdf2 -in awskeys -out awskeys.enc -pass pass:$v_awskeys_password
}

f_a2()
{
rm -rf awskeys
}

f_a3()
{
#
# Build the env file
#
openssl enc -aes-256-cbc -salt -a -pbkdf2 -in awskeys.enc -d -pass pass:$v_VES_P12_PASSWORD -out awskeys.dcr
declare -a args=()
while read line
do
 args+=( "$line" )
done < awskeys.dcr
AWS_ACCESS_KEY_ID=${args[0]}
AWS_SECRET_ACCESS_KEY=${args[1]}
AWS_SESSION_TOKEN=${args[2]}
cat <<EOF >students.env
VES_P12_PASSWORD=$VES_P12_PASSWORD
AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_ID
AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN
EOF
### copy to student working directory
### cp students.env /home/student/.env
}

f_a4()
{
#
# Build the tf vars file
#
startloop=$2
endloop=$3
cat <<EOF >students.auto.tfvars.tmp
aws_region = "us-east-1"
aws_az = "us-east-1a"
ce_ami_id = "ami-000bc40f0b0d64b35"
instance_type = "m5.2xlarge"
volume_size = "80"
ssh_key_name = "./$v_f5xc_ssh_key"
f5xc_api_p12_file = "./$v_certname.p12"
f5xc_api_url = "$v_url"

EOF
if [[ $startloop == 1 || $endloop == 1 ]]; then
 snum="10$startloop"
 snumplus20="12$startloop"
 cat <<EOF >>students.auto.tfvars.tmp
students = {
  "student101" = {
    vpc_cidr        = "172.31.0.0/16"
    slo_subnet_cidr = "172.31.$snum.$snum/24"
    sli_subnet_cidr = "172.31.$snumplus20.$snumplus20/24"
  }
 }
EOF
fi
exit 0
for (( a = $startloop; a <= $endloop; a++ )); do
 cat <<EOF >>students.auto.tfvars.tmp
  students = {
    "student101" = {
      vpc_cidr        = "172.31.0.0/16"
      slo_subnet_cidr = "172.31.101.101/24"
      sli_subnet_cidr = "172.31.121.121/24"
    }
   }
EOF
done
}

f_s1()
{
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/system/securemesh_site_v2s" | jq -r .[][].name
}

f_s2()
{
s_aws_ce_name="demo-smsv2-ce-aws2"
echo "Creating SMSv2 CE $s_aws_ce_name on XC ..."
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/system/securemesh_site_v2s" -d '{"metadata":{"name":"'$s_aws_ce_name'","namespace":"system","labels":{"ves.io/provider":"ves-io-AWS"}},"spec":{"aws":{"not_managed":{"node_list":[]}},"block_all_services":{},"disable_ha":{},"disable_log_anonymization":{},"disable_management_network":{},"disable_url_categorization":{},"dns_ntp_config":{"f5_dns_default":{},"f5_ntp_default":{}},"f5_proxy":{},"load_balancing":{"vip_vrrp_mode":"VIP_VRRP_ENABLE"},"local_vrf":{"default_config":{},"default_sli_config":{}},"logs_streaming_disabled":{},"no_forward_proxy":{},"no_network_policy":{},"no_proxy_bypass":{},"no_s2s_connectivity_sli":{},"no_s2s_connectivity_slo":{},"offline_survivability_mode":{"no_offline_survivability_mode":{}},"operating_system_version":"","performance_enhancement_mode":{"perf_mode_l7_enhanced":{"jumbo_disabled":{}}},"re_select":{"geo_proximity":{}},"site_errors":[],"software_settings":{"os":{"default_os_version":{}},"sw":{"default_sw_version":{}},"waf_signatures":{"manual":{}}},"tunnel_type":"SITE_TO_SITE_TUNNEL_IPSEC_OR_SSL","upgrade_settings":{"kubernetes_upgrade_drain":{"enable_upgrade_drain":{"disable_vega_upgrade_mode":{},"drain_max_unavailable_node_count":1,"drain_node_timeout":300}}},"volterra_software_version":"","site_type":"CUSTOMER_EDGE"}}'
sleep 1
echo "Done ..."
}

### WAAP functions

f_waap_create_single_student_objects()
{
### Create labs 1-3 for a student
### Create the port number for the origin pool range is 1001 to 1012
### Tenant matters for JuiceShop check which tenant environment we are using
### WAAP Lab 3 uses studentX-juice.f5training1.cloud
fqdn="$1-juice.f5training1.cloud"
s_juice_ip="23.22.60.254"
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
echo "Malicious user mitigations in shared namespace ..."
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/shared/malicious_user_mitigations" | jq -r .[][].name | grep -E $1
echo "User identifications in shared namespace ..."
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/shared/user_identifications" | jq -r .[][].name | grep -E $1
}

f_waap_delete_single_student_objects()
{
### Only need to delete student namespace to delete all objects
### If only delete the HTTP load balancer it removes half of the objects as well
echo "Deleting namespace ..."
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/web/namespaces/$1/cascade_delete" | jq
sleep 2
echo "Revoking API credentials ..."
apicreds_list="$(curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/web/namespaces/system/api_credentials" | jq -r .[][].name | grep -E $1)"
for apicred_name in ${apicreds_list[@]}; do
 curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/web/namespaces/system/revoke/api_credentials" -d '{"name":"'$apicred_name'"}' | jq
done
echo "Deleting user mitigations in shared namespace ..."
mu_list="$(curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/shared/malicious_user_mitigations" | jq -r .[][].name | grep -E $1)"
for mu_name in ${mu_list[@]}; do
 curl -s -H "Authorization: APIToken $v_token" -X DELETE "$v_url/config/namespaces/shared/malicious_user_mitigations/$mu_name" | jq
done
echo "Deleting user identifications in shared namespace ..."
ui_list="$(curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/shared/user_identifications" | jq -r .[][].name | grep -E $1)"
for ui_name in ${ui_list[@]}; do
 curl -s -H "Authorization: APIToken $v_token" -X DELETE "$v_url/config/namespaces/shared/user_identifications/$ui_name" | jq
done
echo "Run the -walst and -lso options again to check for object outliers and manually delete them ..."
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
 echo "Deleting user mitigations in shared namespace ..."
 mu_list="$(curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/shared/malicious_user_mitigations" | jq -r .[][].name | grep -E $1)"
 for mu_name in ${mu_list[@]}; do
  curl -s -H "Authorization: APIToken $v_token" -X DELETE "$v_url/config/namespaces/shared/malicious_user_mitigations/$mu_name" | jq
 done
 echo "Deleting user identifications in shared namespace ..."
 ui_list="$(curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/shared/user_identifications" | jq -r .[][].name | grep -E $1)"
 for ui_name in ${ui_list[@]}; do
  curl -s -H "Authorization: APIToken $v_token" -X DELETE "$v_url/config/namespaces/shared/user_identifications/$ui_name" | jq
 done
done
echo "Run the -walst and -lso options again to check for object outliers and manually delete them ..."
}

### main

f_echo "F5 Training $product_name script Version $script_ver"

if [ $# -eq 0 ]; then
f_usage
fi

f_log start
while [ $# -gt 0 ]; do
 case "$1" in
   -tok)
   f_test_token
   ;;
   -lab33)
   f_echo "Building namespace, healthcheck, pool, load balancer for Lab 3.3..."
   f_lab33
   ;;
   -lab63)
   if [ "$#" != 2 ]; then
    f_echo "Missing student name ... "
    exit 1
   fi
   f_echo "Building pool, load balancer for Lab 6.3..."
   f_lab63 $2
   ;;
   -cert)
   if [ "$#" != 2 ]; then
    f_echo "Missing Certificate password ... "
   exit 1
   fi
   v_VES_P12_PASSWORD="$2"
   f_echo "Get F5XC API Certificate ..."
   f_cert
   ;;
   -keys)
   f_echo "Retrieve AWS Keys ..."
   f_echo "Not built ..."
   ;;
   -a1)
   if [ "$#" != 2 ]; then
    f_echo "Missing password ... "
   exit 1
   fi
   v_awskeys_password="$2"
   f_echo "Encrypt AWS keys ..."
   f_a1
   ;;
   -a2)
   f_echo "Remove AWS keys file ..."
   f_a2
   ;;
   -a3)
   f_echo "Create env file ..."
   f_a3
   ;;
   -a4)
   if [ "$#" != 2 ]; then
    f_echo "Missing password ... "
   exit 1
   fi
   echo ""
   echo "This option will create all the SMSv2 CE resources for several students"
   echo "Enter a start and finish number from 1 to 12, the maximum number of students is 12"
   echo ""
   echo "If 3 to 5, then only resources for student103 to student105 are created, if 1 to 12,"
   echo "then resources for student101 to student112 are created"
   echo ""
   read -p "Start number ?" startnum
   read -p "Finish number ?" finishnum
   snumdigits_startnum=`echo $startnum | wc -m`
   snumdigits_finishnum=`echo $finishnum | wc -m`
   if [[ $snumdigits_startnum != 2 || $snumdigits_startnum != 2 ]]; then
    exit 1
   fi
   if [[ $startnum < 1 || $finishnum > 12 ]]; then
    exit 1
   fi
   read -p "Are you sure you wish to continue (y/n) ?" choice
   if [ "$choice" = "y" ]; then
    echo ""
    f_echo "Creating student terraform vars file for student$startnum to student$finishnum ..."
    f_a4 $2 $startnum $finishnum
   else
    echo "Exiting ..."
    exit 0
   fi
   ;;
   -s1)
   f_echo "List current SMSv2 CEs ..."
   f_s1
   ;;
   -s2)
   f_echo "Creating SMSv2 CE object on XC ..."
   f_s2
   ;;
   -w1)
   if [ "$#" != 2 ]; then
    f_echo "Missing student name ... "
    exit 1
   fi
   f_echo "Creating WAAP labs 1-3 objects for $2 ..."
   f_waap_create_single_student_objects $2
   ;;
   -w2)
   if [ "$#" != 2 ]; then
    f_echo "Missing student name ... "
    exit 1
   fi
   f_echo "List first WAAP lab objects for $2 ..."
   f_waap_list_single_student_objects $2
   ;;
   -w3)
   if [ "$#" != 2 ]; then
    f_echo "Missing student name ... "
    exit 1
   fi
   f_echo "Deleting all WAAP objects for $2 ..."
   f_waap_delete_single_student_objects $2
   ;;
   -w4)
   f_echo "Deleting all WAAP student objects ..."
   f_waap_delete_all_student_objects
   ;;
   *)
   ;;
 esac
 shift
done
f_log finish
f_echo "End ..."
