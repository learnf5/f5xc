#!/bin/bash

### variables

product_name="F5 Distributed Cloud"
script_ver="1.0"
script_name="azure1.sh"
student_name=$2

v_token=""
v_url="https://training1.console.ves.volterra.io/api"
v_tenant="training1-rcfjmagj"
v_dom="f5training1.cloud"
v_azure_creds_name="creds-azr1211gst01"
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
echo "Classroom 1 setup script for Deploying an Application to Microsoft Azure"
echo ""
echo "Student numbers run from 101 to 112"
echo ""
echo "Usage: ./${script_name} -option"
echo ""
echo "Options:"
echo ""
echo "-tok                       Test token"
echo "-s23 <studentname>         Create labs 2-3 objects (namespace, key, label, VNET)"
echo "-s3 <studentname>          Apply Azure VNET site created in lab 3"
echo "-s4 <studentname>          Create Lab 4 objects (vK8s)"
echo "-s5 <studentname>          Create lab 5 objects (HTTPS load balancer, Origin Pool, Origin Server)"
echo "-s6 <studentname>          Create lab 6 objects (HTTP load balancer)"
echo ""
exit 0
}

f_test_token()
{
curl -s -X GET -H "Authorization: APIToken $v_token" $v_url/web/namespaces | jq
}

f_labs23()
{
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
s_key="$1-key"
s_value="$1-value"
s_vsite_name="$1-vsite"
s_azure_site_name="$1-vnet"
s_azure_vnet_name="$1-vnet"
s_azure_resource_group="$1-rg"
s_azure_region="eastus"
echo "Creating Namespace for $1 ..."
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/web/namespaces" -d '{"metadata":{"name":"'$1'"},"spec":{}}' | jq
sleep 1
echo "Creating key, label, and virtual site for $1 ..."
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/shared/known_label_key/create" -d '{"key":"'$s_key'","namespace":"'$1'"}'
sleep 1
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/shared/known_label/create" -d '{"key":"'$s_key'","namespace":"'$1'","value":"'$s_value'"}'
sleep 1
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/shared/virtual_sites" -d '{"metadata":{"name":"'$s_vsite_name'","namespace":"'$1'"},"spec":{"site_selector":{"expressions":["'$s_key' in ('$s_value')"]},"site_type":"CUSTOMER_EDGE"}}'
sleep 1
echo "Creating Azure VNET site configuration for $1 ..."
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/system/azure_vnet_sites" -d '{"metadata":{"name":"'$s_azure_site_name'","namespace":"system","labels":{"domain":"","'$s_key'":"'$s_value'"}},"spec":{"resource_group":"'$s_azure_resource_group'","azure_region":"'$s_azure_region'","vnet":{"new_vnet":{"name":"'$s_azure_vnet_name'","primary_ipv4":"172.31.0.0/16"}},"ingress_gw":{"az_nodes":[{"azure_az":"1","local_subnet":{"subnet_param":{"ipv4":"172.31.'$snum'.0/24","ipv6":""}},"disk_size":0}],"azure_certified_hw":"azure-byol-voltmesh","performance_enhancement_mode":{"perf_mode_l7_enhanced":{}},"accelerated_networking":{"enable": {}}},"azure_cred":{"tenant":"'$v_tenant'","namespace":"system","name":"'$v_azure_creds_name'"},"machine_type":"Standard_D3_v2","disk_size":0,"ssh_key":"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDc+HSquvm6Bbvnk4h2KMR51MwnzBPWzbmhK5tiW8sC4rh+VzrcjNgnrc4Op7tFtLkv2sq/Vecg9QB6jMamGoBrqWP3qjejSxYWwr8xP/ZNRlqJNwGxEAQlDkUkKtUfNWgmOZtoVq249vvewyUCbmOlpgFDPPeNGfQrutJkOHmUj53kEIhhkoE+ZieY2Ls5fHTNgUDznf8KysnrIAr+reEKt7FREL+4kKnCp9ZlZtw/nw5sSDFNU9PRZuTwZIE85oY9nDxe9fRRttBSMHq9g0GD0iZg9fjafuB0Ft7qzkSq20vGrtYxfGgPW8kIjZBA95CSyA2gRsnSxUF7Fq+W50EWZfqU4O9KOZwKo8dTcbjmS+S5S5avK37uVn1v99rdG3Z9xbfBW8tohARDGlzC1R1Qh+LrfPgjds7oKXewT6hiHDe0wsMp25IxYUGEHqdEaAs4Bfos4Qw2Lwhjc2brNAO1aD9VpQPf9RMkv+gEDLoWdLEHw+qpRInDcO1N3kt8bQM= student@PC01","logs_streaming_disabled":{},"no_worker_nodes":{},"default_blocked_services":{},"offline_survivability_mode":{"no_offline_survivability_mode":{}}}}'
sleep 1
echo ""
echo "Azure site verification is very slow, run apply in the next script option ..."
echo ""
echo "First go to the F5XC console and wait for it to indicate Validation Succeeded ..."
echo ""
echo "The Azure VNET site configuration needs to be applied using the -s3 option for $1 ..."
}

f_labs3()
{
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
s_azure_vnet_name="$1-vnet"
echo "Status of Terraform Plan for Azure VNET site configuration for $1 ..."
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/system/terraform_parameters/azure_vnet_site/$s_azure_vnet_name/status" | jq
sleep 2
echo "Applying Terraform Plan for Azure VNET site configuration for $1 ..."
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/terraform/namespaces/system/terraform/azure_vnet_site/$s_azure_vnet_name/run" -d '{"action":"APPLY"}'
echo ""
echo "Check the GUI for the green Apply button and check Azure. Process takes some minutes to run ..."
}

f_labs4()
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
echo "Decoding file ..."
cat encoded_ves_$1_$1-vk8s.yaml | jq -r '.data' | base64 --decode 1>ves_$1_$1-vk8s.yaml
sleep 1
echo "Copying kubeconfig file to /home/student/.kube/config ..."
cp ves_$1_$1-vk8s.yaml /home/student/.kube/config
sleep 1
echo "Deploying f5trnapp application ..."
cd /home/student/f5xc/xc-admin-course
kubectl apply -f f5trnapp.yaml
}

f_labs5()
{
echo "Creating Health check for Origin Pool for $1 ..."
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$1/healthchecks" -d '{"metadata":{"name":"'$1'-hc"},"spec":{"healthy_threshold":3,"http_health_check":{"expected_status_codes":["200"],"path":"/"},"interval":15,"timeout":3,"jitter_percent":30,"unhealthy_threshold":1}}' | jq
sleep 1
s_op="$1-op"
s_service="f5trnapp.$1"
echo "Creating Origin Pool for $1 ..."
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$1/origin_pools" -d '{"metadata":{"name":"'$s_op'"},"spec":{"origin_servers":[{"k8s_service":{"service_name":"'$s_service'","site_locator":{"virtual_site":{"tenant":"'$v_tenant'","namespace":"shared","name":"'$1'-vsite"}},"vk8s_networks":{}},"labels":{}}],"no_tls":{},"port":3005,"same_as_endpoint_port":{},"healthcheck":[{"tenant":"'$v_tenant'","namespace":"'$1'","name":"'$1'-hc"}],"loadbalancer_algorithm":"LB_OVERRIDE","endpoint_selection":"LOCAL_PREFERRED","advanced_options":null}}'
sleep 1
s_lb="$1-https-lb"
s_dom="$1.$v_dom"
echo "Creating HTTPS Load Balancer for $1 ..."
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$1/http_loadbalancers" -d '{"metadata":{"name":"'$s_lb'"},"spec":{"domains":["'$s_dom'"],"https_auto_cert":{"http_redirect":true,"add_hsts":true,"tls_config":{"default_security":{}},"no_mtls":{},"default_header":{},"enable_path_normalize":{},"port":443,"non_default_loadbalancer":{},"header_transformation_type":{"default_header_transformation":{}},"connection_idle_timeout": 120000,"http_protocol_options":{"http_protocol_enable_v1_v2":{}}},"advertise_on_public_default_vip":{},"default_route_pools":[{"pool":{"tenant":"'$v_tenant'","namespace":"'$1'","name":"'$s_op'"},"weight":1,"priority":1,"endpoint_subsets":{}}],"origin_server_subset_rule_list":null,"disable_waf":{},"add_location":true,"no_challenge":{},"more_option":null,"user_id_client_ip":{},"disable_rate_limit":{},"malicious_user_mitigation":null,"waf_exclusion_rules":[],"data_guard_rules":[],"blocked_clients":[],"trusted_clients":[],"api_protection_rules":null,"ddos_mitigation_rules":[],"service_policies_from_namespace":{},"round_robin":{},"disable_trust_client_ip_headers":{},"disable_ddos_detection":{},"disable_malicious_user_detection":{},"disable_api_discovery":{},"disable_bot_defense":{},"disable_api_definition":{},"disable_ip_reputation":{},"disable_client_side_defense":{},"csrf_policy":null,"graphql_rules":[],"protected_cookies":[],"host_name":"","dns_info":[],"dns_records":[],"state_start_time":null}}'
sleep 1
echo ""
echo "Now make a browser connection to the f5trnapp application at https://studentX.$v_dom"
echo ""
echo "It will take several minutes for the load balancer to be provisioned and active in F5XC"
echo ""
}

f_labs6()
{
s_op="$1-op"
s_service="f5trnapp.$1"
s_lb="$1-http-lb"
s_dom="$s_lb.$v_dom"
echo "Creating HTTP Load Balancer for $1 ..."
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$1/http_loadbalancers" -d '{"metadata":{"name":"'$s_lb'","namespace":"'$1'"},"spec":{"add_location":true,"advertise_on_public_default_vip":{},"api_protection_rules":null,"api_rate_limit_legacy":null,"auto_cert_info":{"auto_cert_expiry":null,"auto_cert_issuer":"","auto_cert_state":"AutoCertNotApplicable","auto_cert_subject":"","dns_records":[],"state_start_time":null},},"blocked_clients":[],"cert_state":"AutoCertNotApplicable","cors_policy":null,"csrf_policy":null,"data_guard_rules":[],"ddos_mitigation_rules":[],"default_route_pools":[{"endpoint_subsets":{},"pool":{"name":"'$s_op'","namespace":"'$1'","tenant":"'$v_tenant'"},"priority":1,"weight":1}],"default_sensitive_data_policy":{},"disable_api_definition":{},"disable_api_discovery":{},"disable_api_testing":{},"disable_bot_defense":{},"disable_client_side_defense":{},"disable_ip_reputation":{},"disable_malicious_user_detection":{},"disable_malware_protection":{},"disable_rate_limit":{},"disable_threat_mesh":{},"disable_trust_client_ip_headers":{},"disable_waf":{},"dns_info":[{"internal_cdn_service_domain":""}],"domains":["'$s_dom'"],"downstream_tls_certificate_expiration_timestamps":[],"graphql_rules":[],"http":{"dns_volterra_managed":true,"port":3005},"internet_vip_info":[],"jwt_validation":null,"l7_ddos_protection":{"clientside_action_none":{},"ddos_policy_none":{},"mitigation_block":{},"rps_threshold":0},"malicious_user_mitigation":null,"more_option":null,"no_challenge":{},"origin_server_subset_rule_list":null,"protected_cookies":[],"round_robin":{},"routes":[],"sensitive_data_disclosure_rules":null,"service_policies_from_namespace":{},"system_default_timeouts":{},"trusted_clients":[],"user_id_client_ip":{},"waf_exclusion":null,"waf_exclusion_rules":[]}}'
sleep 1
echo ""
echo "Now make a browser connection to the f5trnapp application at http://$s_dom"
echo ""
echo "It will take several minutes for the load balancer to be provisioned and active in F5XC"
echo ""
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
   -s23)
   if [ "$#" != 2 ]; then
    f_echo "Missing student name ... "
    exit 1
   fi
   f_echo "Creating labs 2-3 objects for $2 ..."
   f_labs23 $2
   ;;
   -s3)
   if [ "$#" != 2 ]; then
    f_echo "Missing student name ... "
    exit 1
   fi
   f_echo "Applying lab 3 Azure VNET site objects for $2 ..."
   f_labs3 $2
   ;;
   -s4)
   if [ "$#" != 2 ]; then
    f_echo "Missing student name ... "
    exit 1
   fi
   f_echo "Creating lab 4 vK8s object, downloading Kubeconfig file for $2, and deploying application ..."
   f_labs4 $2
   ;;
   -s5)
   if [ "$#" != 2 ]; then
    f_echo "Missing student name ... "
    exit 1
   fi
   f_echo "Creating lab 5 objects for $2 ..."
   f_labs5 $2
   ;;
   -s6)
   if [ "$#" != 2 ]; then
    f_echo "Missing student name ... "
    exit 1
   fi
   f_echo "Creating lab 6 objects for $2 ..."
   f_labs6 $2
   ;;
   *)
   ;;
 esac
 shift
done
f_log finish
f_echo "End ..."
