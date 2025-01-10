#!/bin/bash

### variables

product_name="F5 Distributed Cloud"
script_ver="1.1"
script_name="mc.sh"
student_name=$2

### default values
### Adjust to whatever tenant and DNS domain in use
v_tenant="training-dev-fcphvhww"
v_dom="dev.learnf5.cloud"
v_aws_creds_name="learnf5-aws"
v_azure_creds_name="all-students-credentials"
v_token="FREqoGYFFHzhM0iLQKkQ9TK5y3N0/xA="
v_url="https://training-dev.console.ves.volterra.io/api"
v_aws1_site_name="student99-vpc1"
v_aws2_site_name="student99-vpc2"
v_azure1_site_name="student99-vnet1"
v_namespace_1="student99-brews"
v_namespace_1_cert="abcd"
v_namespace_1_key="bcd"
v_app_name_1="brews99"
v_brews_spa_domain="brews99.aws.learnf5.cloud"
v_brews_recs_domain="recs99.aws.learnf5.cloud"
v_brews_inv_domain="inventory99.brews.local"
v_brews_mongodb_domain="mongodb99.brews.local"
v_namespace_1_cert="abcd"
v_namespace_1_key="bcd"
v_use_https="no"
v_use_autocert="yes"
v_brews_spa_api_waf="brews-spa-api-appwf"
v_registry_name="f5demos"
v_brews_mongodb_name="brews-mongodb"
v_mongodb_container_name="mongo"
v_spa_container_name="brews-spa"
v_api_container_name="brews-api"
v_inv_container_name="brews-inv"
v_recs_container_name="brews-recs"
v_base64_cert=""
v_base64_key=""

### v_dom="learnf5.cloud"

### functions

f_echo()
{
echo -e $1
}

f_usage()
{
echo "Class setup script for Multi Cloud Brews Distributed Application"
echo ""
echo "Usage: ./${script_name} -option <studentname>"
echo ""
echo "Options:"
echo ""
echo "-sa                            Test token"
echo "-sb                            Print variables"
echo "-a1                            Create VPC site 1"
echo "-a2                            Create VPC site 2"
echo "-a3                            Create VNET site 1"
echo ""
echo "Cloud Site Status"
echo ""
echo "-s1                            AWS VPC site 1 status"
echo "-s2                            AWS VPC site 2 status"
echo "-s3                            Azure VNET site 1 status"
echo ""
echo "Base Configuration"
echo ""
echo "-s4                            Create namespace 1"
echo "-s5                            Create MCN label key"
echo "-s6                            Create MCN label"
echo "-s7                            Create Brews workload"
echo "-s8                            Create SPA WAF"
echo ""
echo "vK8s and vsites"
echo ""
echo "-s9 -mccvs                     Create MCN vsite"
echo "-s10 -mccre                    Create RE vsite"
echo "-s11 -mccaz                    Create Azure 1 vsite"
echo "-s12 -mcca1                    Create AWS 1 vsite"
echo "-s13 -mcca2                    Create AWS 2 vsite"
echo "-s14 -mccvk                    Create vK8s cluster"
echo "-s15 -mcgvk                    Get vK8s cluster status"
echo ""
echo "Workloads"
echo ""
echo "-s16 -mcwl1                    Create Container Registry"
echo "-s17 -mcwl2                    Deploy Mongodb"
echo "-s18 -mcwl3                    Deploy SPA"
echo "-s19 -mcwl4                    Deploy API"
echo "-s20 -mcwl5                    Deploy Inventory"
echo "-s21 -mcwl6                    Deploy Recommendations HTTPS LB manual cert cleartext"
echo "-s22 -mcwl7                    Deploy Recommendations HTTPS LB manual cert blindfold"
echo "-s23 -mcwl8                    Deploy Recommendations HTTPS LB autocert"
echo "-s24 -mcwl9                    Deploy Recommendations HTTPS LB"
echo ""
echo "Deployments"
echo ""
echo "-s25 -mcdp1                    Delete Recommendations deployment "
echo "-s26 -mcdp2                    Delete Inventory deployment "
echo "-s27 -mcdp3                    Delete API deployment "
echo "-s28 -mcdp4                    Delete SPA deployment "
echo "-s29 -mcdp5                    Delete Mongodb deployment "
echo "-s30 -mcdp6                    Deploy Mongodb"
echo "-s31 -mcdp7                    Deploy SPA"
echo "-s32 -mcdp8                    Deploy API"
echo "-s33 -mcdp9                    Deploy Inventory"
echo "-s34 -mcdp10                   Deploy Recommendations"
echo ""
echo "Load Balancing and WAAP"
echo ""
echo "-s35 -mclb1                    Create Mongodb healthcheck"
echo "-s36 -mclb2                    Create API healthcheck"
echo "-s37 -mclb3                    Create SPA healthcheck"
echo "-s38 -mclb4                    Create INV healthcheck"
echo "-s39 -mclb5                    Create Mongodb origin pool"
echo "-s40 -mclb6                    Create API origin pool"
echo "-s41 -mclb7                    Create SPA origin pool"
echo "-s42 -mclb8                    Create INV origin pool"
echo "-s43 -mclb9                    Create Mongodb TCP load balancer (internal)"
echo "-s44 -mclb10                   Create INV HTTP load balancer (internal)"
echo "-s45 -mclb11                   Create SPA-API HTTPS lb (public manual cert cleartext)"
echo "-s46 -mclb12                   Create SPA-API HTTPS lb (public manual cert blindfold)"
echo "-s47 -mclb13                   Create SPA-API HTTPS lb (public autocert)"
echo "-s48 -mclb14                   Create SPA-API HTTPS lb (public)"
echo ""
exit 0
}

f_test_token()
{
curl -s -X GET -H "Authorization: APIToken $v_token" $v_url/web/namespaces | jq
}

f_print_vars()
{
echo ""
echo "Variables set to:"
echo ""
echo $v_namespace_1, $v_aws1_site_name, $v_aws2_site_name, $v_azure1_site_name, $v_namespace_1, $v_app_name_1, $v_brews_spa_domain, $v_brews_recs_domain, $v_brews_inv_domain, $v_brews_mongodb_domain
echo ""
}

f_mc_a1()
{
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/system/aws_vpc_sites" -d '{"metadata":{"name":"'$v_aws1_site_name'","namespace":"system","labels":{"'$v_aws1_key1'":"'$v_aws1_key1_value'","'$v_key2'":"'$v_key2_value'","'$v_aws1_key3'":"'$v_aws1_key3_value'"}},"spec":{"vpc":{"new_vpc":{"autogenerate":{},"primary_ipv4":"172.31.0.0/16","allocate_ipv6":false}},"ingress_gw":{"az_nodes":[{"aws_az_name":"us-east-1a","local_subnet":{"subnet_param":{"ipv4":"172.31.'$snum'.0/24"}},"disk_size":0}],"aws_certified_hw":"aws-byol-voltmesh","allowed_vip_port":{"use_http_https_port":{}},"performance_enhancement_mode":{"perf_mode_l7_enhanced":{}}},"aws_cred":{"tenant":"'$v_tenant'","namespace":"system","name":"'$v_aws_creds_name'"},"instance_type":"m5.4xlarge","disk_size":0,"volterra_software_version":"","operating_system_version":"","aws_region":"us-east-1","ssh_key":"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDc+HSquvm6Bbvnk4h2KMR51MwnzBPWzbmhK5tiW8sC4rh+VzrcjNgnrc4Op7tFtLkv2sq/Vecg9QB6jMamGoBrqWP3qjejSxYWwr8xP/ZNRlqJNwGxEAQlDkUkKtUfNWgmOZtoVq249vvewyUCbmOlpgFDPPeNGfQrutJkOHmUj53kEIhhkoE+ZieY2Ls5fHTNgUDznf8KysnrIAr+reEKt7FREL+4kKnCp9ZlZtw/nw5sSDFNU9PRZuTwZIE85oY9nDxe9fRRttBSMHq9g0GD0iZg9fjafuB0Ft7qzkSq20vGrtYxfGgPW8kIjZBA95CSyA2gRsnSxUF7Fq+W50EWZfqU4O9KOZwKo8dTcbjmS+S5S5avK37uVn1v99rdG3Z9xbfBW8tohARDGlzC1R1Qh+LrfPgjds7oKXewT6hiHDe0wsMp25IxYUGEHqdEaAs4Bfos4Qw2Lwhjc2brNAO1aD9VpQPf9RMkv+gEDLoWdLEHw+qpRInDcO1N3kt8bQM= student@PC01","address":"","logs_streaming_disabled":{},"vip_params_per_az":[],"no_worker_nodes": {},"default_blocked_services":{},"direct_connect_disabled":{},"offline_survivability_mode":{"no_offline_survivability_mode":{}},"enable_internet_vip":{},"egress_gateway_default":{},"suggested_action":"","error_description":"","f5xc_security_group":{},"direct_connect_info":null}}'
sleep 4
echo "Checking status of Terraform Plan for AWS VPC site 1 ..."
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/system/terraform_parameters/aws_vpc_site/$v_aws1_site_name/status" | jq
sleep 2
echo "Applying Terraform Plan for AWS VPC site 1 ..."
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/terraform/namespaces/system/terraform/aws_vpc_site/$v_aws1_site_name/run" -d '{"action":"APPLY"}'
}

f_mc_a2()
{
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/system/aws_vpc_sites" -d '{"metadata":{"name":"'$v_aws2_site_name'","namespace":"system","labels":{"'$v_aws2_key1'":"'$v_aws2_key1_value'","'$v_key2'":"'$v_key2_value'","'$v_aws2_key3'":"'$v_aws2_key3_value'"}},"spec":{"vpc":{"new_vpc":{"autogenerate":{},"primary_ipv4":"172.31.0.0/16","allocate_ipv6":false}},"ingress_gw":{"az_nodes":[{"aws_az_name":"us-east-1a","local_subnet":{"subnet_param":{"ipv4":"172.31.'$snum'.0/24"}},"disk_size":0}],"aws_certified_hw":"aws-byol-voltmesh","allowed_vip_port":{"use_http_https_port":{}},"performance_enhancement_mode":{"perf_mode_l7_enhanced":{}}},"aws_cred":{"tenant":"'$v_tenant'","namespace":"system","name":"'$v_aws_creds_name'"},"instance_type":"m5.4xlarge","disk_size":0,"volterra_software_version":"","operating_system_version":"","aws_region":"us-east-1","ssh_key":"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDc+HSquvm6Bbvnk4h2KMR51MwnzBPWzbmhK5tiW8sC4rh+VzrcjNgnrc4Op7tFtLkv2sq/Vecg9QB6jMamGoBrqWP3qjejSxYWwr8xP/ZNRlqJNwGxEAQlDkUkKtUfNWgmOZtoVq249vvewyUCbmOlpgFDPPeNGfQrutJkOHmUj53kEIhhkoE+ZieY2Ls5fHTNgUDznf8KysnrIAr+reEKt7FREL+4kKnCp9ZlZtw/nw5sSDFNU9PRZuTwZIE85oY9nDxe9fRRttBSMHq9g0GD0iZg9fjafuB0Ft7qzkSq20vGrtYxfGgPW8kIjZBA95CSyA2gRsnSxUF7Fq+W50EWZfqU4O9KOZwKo8dTcbjmS+S5S5avK37uVn1v99rdG3Z9xbfBW8tohARDGlzC1R1Qh+LrfPgjds7oKXewT6hiHDe0wsMp25IxYUGEHqdEaAs4Bfos4Qw2Lwhjc2brNAO1aD9VpQPf9RMkv+gEDLoWdLEHw+qpRInDcO1N3kt8bQM= student@PC01","address":"","logs_streaming_disabled":{},"vip_params_per_az":[],"no_worker_nodes": {},"default_blocked_services":{},"direct_connect_disabled":{},"offline_survivability_mode":{"no_offline_survivability_mode":{}},"enable_internet_vip":{},"egress_gateway_default":{},"suggested_action":"","error_description":"","f5xc_security_group":{},"direct_connect_info":null}}'
sleep 4
echo "Checking status of Terraform Plan for AWS VPC site 2 ..."
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/system/terraform_parameters/aws_vpc_site/$v_aws2_site_name/status" | jq
sleep 2
echo "Applying Terraform Plan for AWS VPC site 2 ..."
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/terraform/namespaces/system/terraform/aws_vpc_site/$v_aws2_site_name/run" -d '{"action":"APPLY"}'
}

f_mc_a3()
{
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/system/azure_vnet_sites" -d '{"metadata":{"name":"'$v_azure1_site_name'","namespace":"system","labels":{}},"spec":{"vnet":{"new_vnet":{"autogenerate":{},"primary_ipv4":"172.31.0.0/16","allocate_ipv6":false}},"ingress_gw":{"az_nodes":[{"aws_az":"us-east-1a","local_subnet":{"subnet_param":{"ipv4":"172.31.'$snum'.0/24"}},"disk_size":0}],"azure_certified_hw":"azure-byol-voltmesh","allowed_vip_port":{"use_http_https_port":{}},"performance_enhancement_mode":{"perf_mode_l7_enhanced":{}}},"aws_cred":{"tenant":"'$v_tenant'","namespace":"system","name":"'$v_azure_creds_name'"},"machine_type":"Standard_D3_v2","disk_size":0,"volterra_software_version":"","operating_system_version":"","azure_region":"eastus","ssh_key":"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDc+HSquvm6Bbvnk4h2KMR51MwnzBPWzbmhK5tiW8sC4rh+VzrcjNgnrc4Op7tFtLkv2sq/Vecg9QB6jMamGoBrqWP3qjejSxYWwr8xP/ZNRlqJNwGxEAQlDkUkKtUfNWgmOZtoVq249vvewyUCbmOlpgFDPPeNGfQrutJkOHmUj53kEIhhkoE+ZieY2Ls5fHTNgUDznf8KysnrIAr+reEKt7FREL+4kKnCp9ZlZtw/nw5sSDFNU9PRZuTwZIE85oY9nDxe9fRRttBSMHq9g0GD0iZg9fjafuB0Ft7qzkSq20vGrtYxfGgPW8kIjZBA95CSyA2gRsnSxUF7Fq+W50EWZfqU4O9KOZwKo8dTcbjmS+S5S5avK37uVn1v99rdG3Z9xbfBW8tohARDGlzC1R1Qh+LrfPgjds7oKXewT6hiHDe0wsMp25IxYUGEHqdEaAs4Bfos4Qw2Lwhjc2brNAO1aD9VpQPf9RMkv+gEDLoWdLEHw+qpRInDcO1N3kt8bQM= student@PC01","address":"","logs_streaming_disabled":{},"vip_params_per_az":[],"no_worker_nodes": {},"default_blocked_services":{},"direct_connect_disabled":{},"offline_survivability_mode":{"no_offline_survivability_mode":{}},"enable_internet_vip":{},"egress_gateway_default":{},"suggested_action":"","error_description":"","f5xc_security_group":{},"direct_connect_info":null}}'
sleep 4
echo "Checking status of Terraform Plan for Azure VNET site 1 ..."
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/system/terraform_parameters/azure_vnet_site/$v_azure1_site_name/status" | jq
sleep 2
echo "Applying Terraform Plan for Azure VNET site 1..."
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/terraform/namespaces/system/terraform/azure_vnet_site/$v_azure1_site_name/run" -d '{"action":"APPLY"}'
}

f_mc_s1()
{
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/system/aws_vpc_sites/$v_aws1_site_name" | jq
}

f_mc_s2()
{
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/system/aws_vpc_sites/$v_aws2_site_name" | jq
}

f_mc_s3()
{
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/system/azure_vnet_sites/$v_azure1_site_name" | jq
}

f_mc_s4()
{
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/web/namespaces" -d '{"metadata":{"name":"'$v_namespace_1'"},"spec":{}}' | jq
}

f_mc_s5()
{
s_key=$v_app_name_1-sites
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/shared/known_label_key/create" -d '{"key":"'$s_key'","namespace":"shared"}'
}

f_mc_s6()
{
s_key=$v_app_name_1-sites
s_value="all-sites"
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/shared/known_label/create" -d '{"key":"'$s_key'","namespace":"shared","value":"'$s_value'"}'
}

f_mc_s7()
{
s_wl_flavor=$v_namespace_1-large-flavor
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/shared/workload_flavors" -d '{"metadata":{"name":"'$s_wl_flavor'","namespace":"shared"},"spec":{"memory":"512","vcpus":0.25,"ephemeral_storage":"0"}}'
}

f_mc_s8()
{
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$v_namespace_1/app_firewalls" -d '{"metadata":{"name":"'$v_brews_spa_api_waf'","namespace":"'$v_namespace_1'"},"spec":{}}'
}

f_mc_mccvs()
{
s_mcn_name=$v_namespace_1-mcn-vsite
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$v_namespace_1/virtual_sites" -d '{"metadata":{"name":"'$s_mcn_name'"},"spec":{"site_type":"CUSTOMER_EDGE","site_selector":{"expressions":["'$v_app_name_1'"-sites in (all-sites)"]}}}'
}

f_mc_mccre()
{
s_re_name=$v_namespace_1-re-vsite
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$v_namespace_1/virtual_sites" -d '{"metadata":{"name":"'$s_re_name'"},"spec":{"site_type":"REGIONAL_EDGE","site_selector":{"expressions":[ves.io/siteName in (ves-io-wes-sea,ves-io-ny8-nyc)]}}}'
}

f_mc_mccaz()
{
s_az_name=$v_azure1_site_name-vsite
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$v_namespace_1/virtual_sites" -d '{"metadata":{"name":"'$s_az_name'"},"spec":{"site_type":"CUSTOMER_EDGE","site_selector":{"expressions":[ves.io/siteName in ("'$v_azure1_site_name'")]}}}'
}

f_mc_mcca1()
{
s_aws1_name=$v_aws1_site_name-vsite
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$v_namespace_1/virtual_sites" -d '{"metadata":{"name":"'$s_aws1_name'"},"spec":{"site_type":"CUSTOMER_EDGE","site_selector":{"expressions":[ves.io/siteName in ("'$v_aws1_site_name'")]}}}'
}

f_mc_mcca2()
{
s_aws2_name=$v_aws1_site_name-vsite
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$v_namespace_1/virtual_sites" -d '{"metadata":{"name":"'$s_aws2_name'"},"spec":{"site_type":"CUSTOMER_EDGE","site_selector":{"expressions":[ves.io/siteName in ("'$v_aws2_site_name'")]}}}'
}

f_mc_mccvk()
{
s_vk8s_name=$v_app_name_1-vk8s
s_mcn_name=$v_namespace_1-mcn-vsite
s_wl_flavor=$v_namespace_1-large-flavor
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$v_namespace_1/virtual_k8ss" -d '{"metadata":{"name":"'$s_vk8s_name'","namespace":"'$v_namespace_1'","disable":"false"},"spec":{"vsite_refs":[{"namespace":"'$v_namespace_1'"","name":"'$s_mcn_name'","kind":"virtual_site"}],"disabled":{},"default_flavor_ref":{"namespace":"shared","name":"'$s_wl_flavour'","kind":"workload_flavor"}}}}}'
}

f_mc_mcgvk()
{
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/$v_namespace_1/virtual_k8ss?report_fields"
}

f_mc_mcwl1()
{
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$v_namespace_1/container_registrys" -d '{"metadata":{"name":"'$v_registry_name'"},"spec":{"registry":"f5demos.azurecr.io","user_name":"1e21992e-4283-4afe-9a89-b3b314f1fd55","password":{"clear_secret_info":{"url":"string:///dVUzOFF+SFZwS1RXYWU0eWVXYkxSblVwbHg2ZXprMm9xWmpNS2FWUg=="},"secret_encoding_type":"EncodingNone"}}}'
}

f_mc_mcwl2()
{
s_aws2_name=$v_aws2_site_name-vsite
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$v_namespace_1/workloads" -d '{"metadata":{"name":"'$v_brews_mongodb_name'","'$v_namespace_1'"},"spec":{"service":{"num_replicas":1,"containers":[{"name":"'$v_mongodb_container_name'","image":{"name":"public.ecr.aws/o2z6z0t3/friday:demo","public":{},"pull_policy":"IMAGE_PULL_POLICY_ALWAYS"},"init_container":null,"flavor":"CONTAINER_FLAVOR_TYPE_TINY","liveness_check":null,"readiness_check":null,"command":null,"args":null}],"volumes":null,"configuration":{"parameters":[{"env_var":{"name":"SEED_FILE","value":"beerProducts.json"}}]},"deploy_options":{"deploy_ce_virtual_sites":{"virtual_site":[{"namespace":"'$v_namespace_1'","name":"'$s_aws2_name'"}]}},"advertise_options":{"advertise_in_cluster":{"port":{"info":{"port":27017,"protocol":"PROTOCOL_TCP","same_as_port":}}}}}},"resource_version":null}}'
}

f_mc_mcwl3()
{
s_mcn_name=$v_namespace_1-vsite
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$v_namespace_1/workloads" -d '{"metadata":{"name":"'$v_spa_container_name'","'$v_namespace_1'"},"spec":{"service":{"num_replicas":1,"containers":[{"name":"'$v_spa_container_name'","image":{"name":"f5demos.azurecr.io/spa","container_registry":{"namespace":"'$v_namespace_1'","name":"f5demos"},"pull_policy":"IMAGE_PULL_POLICY_ALWAYS"},"init_container":null,"flavor":"CONTAINER_FLAVOR_TYPE_TINY","liveness_check":null,"readiness_check":null,"command":null,"args":null}],"volumes":null,"configuration":{"parameters":[{"env_var":{"name":"MONGO_URL","value":"'$v_brews_mongodb_domain'"}},{"env_var":{"name": "INVENTORY_URL","value":"http://'$v_brews_inv_domain'"}},{"env_var":{"name":"RECOMMENDATIONS_URL","value":"https://'$v_brews_recs_domain'"}}]},"deploy_options":{"deploy_ce_virtual_sites":{"virtual_site":[{"namespace":"'$v_namespace_1'","name":"'$s_mcn_name'"}]}},"advertise_options":{"advertise_in_cluster":{"port":{"info":{"port":8081,"protocol":"PROTOCOL_TCP","target_port":80}}}}}},"resource_version":null}}'
}

f_mc_mcwl4()
{
s_aws1_name=$v_aws1_site_name-vsite
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$v_namespace_1/workloads" -d '{"metadata":{"name":"'$v_api_container_name'","'$v_namespace_1'"},"spec":{"service":{"num_replicas":1,"containers":[{"name":"'$v_api_container_name'","image":{"name":"f5demos.azurecr.io/api","container_registry":{"namespace":"'$v_namespace_1'","name":"f5demos"},"pull_policy":"IMAGE_PULL_POLICY_ALWAYS"},"init_container":null,"flavor":"CONTAINER_FLAVOR_TYPE_TINY","liveness_check":null,"readiness_check":null,"command":null,"args":null}],"volumes":null,"configuration":{"parameters":[{"env_var":{"name":"MONGO_URL","value":"'$v_brews_mongodb_domain'"}},{"env_var":{"name": "INVENTORY_URL","value":"http://'$v_brews_inv_domain'"}},{"env_var":{"name":"RECOMMENDATIONS_URL","value":"https://'$v_brews_recs_domain'"}}]},"deploy_options":{"deploy_ce_virtual_sites":{"virtual_site":[{"namespace":"'$v_namespace_1'","name":"'$s_aws1_name'"}]}},"advertise_options":{"advertise_in_cluster":{"port":{"info":{"port":8000,"protocol":"PROTOCOL_TCP","same_as_port":{}}}}}}},"resource_version":null}}'
}

f_mc_mcwl5()
{
s_azure1_name=$v_azure1_site_name-vsite
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$v_namespace_1/workloads" -d '{"metadata":{"name":"'$v_inv_container_name'","'$v_namespace_1'"},"spec":{"service":{"num_replicas":1,"containers":[{"name":"'$v_inv_container_name'","image":{"name":"f5demos.azurecr.io/inv","container_registry":{"namespace":"'$v_namespace_1'","name":"f5demos"},"pull_policy":"IMAGE_PULL_POLICY_ALWAYS"},"init_container":null,"flavor":"CONTAINER_FLAVOR_TYPE_TINY","liveness_check":null,"readiness_check":null,"command":null,"args":null}],"volumes":null,"configuration":{"parameters":[{"env_var":{"name":"MONGO_URL","value":"'$v_brews_mongodb_domain'"}},{"env_var":{"name": "INVENTORY_URL","value":"http://'$v_brews_inv_domain'"}},{"env_var":{"name":"RECOMMENDATIONS_URL","value":"https://'$v_brews_recs_domain'"}}]},"deploy_options":{"deploy_ce_virtual_sites":{"virtual_site":[{"namespace":"'$v_namespace_1'","name":"'$s_azure1_name'"}]}},"advertise_options":{"advertise_in_cluster":{"port":{"info":{"port":8002,"protocol":"PROTOCOL_TCP","same_as_port":{}}}}}}},"resource_version":null}}'
}

f_mc_mcwl6()
{
s_re_name=$v_namespace_1-re-vsite
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$v_namespace_1/workloads" -d '{"metadata":{"name":"'$v_recs_container_name'","'$v_namespace_1'"},"spec":{"service":{"num_replicas":1,"containers":[{"name":"'$v_recs_container_name'","image":{"name":"f5demos.azurecr.io/recs","container_registry":{"namespace":"'$v_namespace_1'","name":"f5demos"},"pull_policy":"IMAGE_PULL_POLICY_ALWAYS"},"init_container":null,"flavor":"CONTAINER_FLAVOR_TYPE_TINY","liveness_check":null,"readiness_check":null,"command":null,"args":null}],"volumes":null,"configuration":{"parameters":[{"env_var":{"name":"MONGO_URL","value":"'$v_brews_mongodb_domain'"}},{"env_var":{"name": "INVENTORY_URL","value":"http://'$v_brews_inv_domain'"}},{"env_var":{"name":"RECOMMENDATIONS_URL","value":"https://'$v_brews_recs_domain'"}}]},"deploy_options":{"deploy_re_virtual_sites":{"virtual_site":[{"namespace":"'$v_namespace_1'","name":"'$s_re_name'"}]}},"advertise_options":{"advertise_on_public":{"port":{"info":{"port":8001,"protocol":"PROTOCOL_TCP","same_as_port":{}}},"http_loadbalancer":{"domains":["'$v_brews_recs_domain'"],"https":{"http_redirect":null,"add_hsts":null,"tls_parameters":{"tls_config":{"default_security":{}},"tls_certificates":[{"certificate_url":"string:///'$v_base64_cert'","private_key":{"clear_secret_info":{"url":"string:///'$v_base64_key'","provider":null},"blindfold_secret_info_internal":null,"secret_encoding_type":"EncodingNone"},"description":null}],"no_mtls":{}},"default_header":{}},"default_route":{"disable_host_rewrite":{}}}}}}},"resource_version":null}}'
}

f_mc_mcwl7()
{
s_re_name=$v_namespace_1-re-vsite
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$v_namespace_1/workloads" -d '{"metadata":{"name":"'$v_recs_container_name'","'$v_namespace_1'"},"spec":{"service":{"num_replicas":1,"containers":[{"name":"'$v_recs_container_name'","image":{"name":"f5demos.azurecr.io/recs","container_registry":{"namespace":"'$v_namespace_1'","name":"f5demos"},"pull_policy":"IMAGE_PULL_POLICY_ALWAYS"},"init_container":null,"flavor":"CONTAINER_FLAVOR_TYPE_TINY","liveness_check":null,"readiness_check":null,"command":null,"args":null}],"volumes":null,"configuration":{"parameters":[{"env_var":{"name":"MONGO_URL","value":"'$v_brews_mongodb_domain'"}},{"env_var":{"name": "INVENTORY_URL","value":"http://'$v_brews_inv_domain'"}},{"env_var":{"name":"RECOMMENDATIONS_URL","value":"https://'$v_brews_recs_domain'"}}]},"deploy_options":{"deploy_re_virtual_sites":{"virtual_site":[{"namespace":"'$v_namespace_1'","name":"'$s_re_name'"}]}},"advertise_options":{"advertise_on_public":{"port":{"info":{"port":8001,"protocol":"PROTOCOL_TCP","same_as_port":{}}},"http_loadbalancer":{"domains":["'$v_brews_recs_domain'"],"https":{"http_redirect":null,"add_hsts":null,"tls_parameters":{"tls_config":{"default_security":{}},"tls_certificates":[{"certificate_url":"string:///'$v_base64_cert'","private_key":{"blindfold_secret_info":{"location":"string:///'$v_namespace_1'-key","decryption_provider":null,"store_provider":null},"blindfold_secret_info_internal":null,"secret_encoding_type":null},"description":null}],"no_mtls":{}},"default_header":{}},"default_route":{"disable_host_rewrite":{}}}}}}}},"resource_version":null}}'
}

f_mc_mcwl8()
{
s_re_name=$v_namespace_1-re-vsite
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$v_namespace_1/workloads" -d '{"metadata":{"name":"'$v_recs_container_name'","'$v_namespace_1'"},"spec":{"service":{"num_replicas":1,"containers":[{"name":"'$v_recs_container_name'","image":{"name":"f5demos.azurecr.io/recs","container_registry":{"namespace":"'$v_namespace_1'","name":"f5demos"},"pull_policy":"IMAGE_PULL_POLICY_ALWAYS"},"init_container":null,"flavor":"CONTAINER_FLAVOR_TYPE_TINY","liveness_check":null,"readiness_check":null,"command":null,"args":null}],"volumes":null,"configuration":{"parameters":[{"env_var":{"name":"MONGO_URL","value":"'$v_brews_mongodb_domain'"}},{"env_var":{"name": "INVENTORY_URL","value":"http://'$v_brews_inv_domain'"}},{"env_var":{"name":"RECOMMENDATIONS_URL","value":"https://'$v_brews_recs_domain'"}}]},"deploy_options":{"deploy_re_virtual_sites":{"virtual_site":[{"namespace":"'$v_namespace_1'","name":"'$s_re_name'"}]}},"advertise_options":{"advertise_on_public":{"port":{"info":{"port":8001,"protocol":"PROTOCOL_TCP","same_as_port":{}}},"http_loadbalancer":{"domains":["'$v_brews_recs_domain'"],"https_auto_cert":{"http_redirect":null,"add_hsts":null,"port":443,"tls_config":{"default_security":{}},"no_mtls":{},"default_header":{},"enable_path_normalize":{},"non_default_loadbalancer":{}},"default_route":{"disable_host_rewrite":{}}}}}}}},"resource_version":null}}'
}

f_mc_mcwl9()
{
s_re_name=$v_namespace_1-re-vsite
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$v_namespace_1/workloads" -d '{"metadata":{"name":"'$v_recs_container_name'","'$v_namespace_1'"},"spec":{"service":{"num_replicas":1,"containers":[{"name":"'$v_recs_container_name'","image":{"name":"f5demos.azurecr.io/recs","container_registry":{"namespace":"'$v_namespace_1'","name":"f5demos"},"pull_policy":"IMAGE_PULL_POLICY_ALWAYS"},"init_container":null,"flavor":"CONTAINER_FLAVOR_TYPE_TINY","liveness_check":null,"readiness_check":null,"command":null,"args":null}],"volumes":null,"configuration":{"parameters":[{"env_var":{"name":"MONGO_URL","value":"'$v_brews_mongodb_domain'"}},{"env_var":{"name": "INVENTORY_URL","value":"http://'$v_brews_inv_domain'"}},{"env_var":{"name":"RECOMMENDATIONS_URL","value":"https://'$v_brews_recs_domain'"}}]},"deploy_options":{"deploy_re_virtual_sites":{"virtual_site":[{"namespace":"'$v_namespace_1'","name":"'$s_re_name'"}]}},"advertise_options":{"advertise_on_public":{"port":{"info":{"port":8001,"protocol":"PROTOCOL_TCP","same_as_port":{}}},"http_loadbalancer":{"domains":["'$v_brews_recs_domain'"],"http":{"dns_volterra_managed":true,"port":80},"default_route":{"disable_host_rewrite":{}}}}}}}},"resource_version":null}}'
}

f_mc_mcdp1()
{
curl -s -H "Authorization: APIToken $v_token" -X DELETE "$v_url/vk8s/namespaces/$v_namespace_1/$v_app_name_1-vk8s/apis/apps/v1/namespaces/$v_namespace_1}/deployments/brews-recs"
}

f_mc_mcdp2()
{
curl -s -H "Authorization: APIToken $v_token" -X DELETE "$v_url/vk8s/namespaces/$v_namespace_1/$v_app_name_1-vk8s/apis/apps/v1/namespaces/$v_namespace_1}/deployments/brews-inv"
}

f_mc_mcdp3()
{
curl -s -H "Authorization: APIToken $v_token" -X DELETE "$v_url/vk8s/namespaces/$v_namespace_1/$v_app_name_1-vk8s/apis/apps/v1/namespaces/$v_namespace_1}/deployments/brews-api"
}

f_mc_mcdp4()
{
curl -s -H "Authorization: APIToken $v_token" -X DELETE "$v_url/vk8s/namespaces/$v_namespace_1/$v_app_name_1-vk8s/apis/apps/v1/namespaces/$v_namespace_1}/deployments/brews-spa"
}

f_mc_mcdp5()
{
curl -s -H "Authorization: APIToken $v_token" -X DELETE "$v_url/vk8s/namespaces/$v_namespace_1/$v_app_name_1-vk8s/apis/apps/v1/namespaces/$v_namespace_1}/deployments/brews-mongodb"
}

f_mc_mcdp6()
{
s_app_vk8s_name=$v_app_name_1-vk8s
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/vk8s/namespaces/$v_namespace_1/$v_namespace_1/$s_app_vk8s_name/apis/apps/v1/namespaces/$v_namespace_1/deployments" -d '{{"kind":"Deployment","apiVersion":"apps/v1","metadata":{"name":"brews-mongodb","namespace":"'$v_namespace_1'","annotations":{"ves.io/virtual-sites":"'$v_namespace_1'/'$v_aws2_site_name'-vsite","ves.io/workload-flavor-brews-api":"'$v_namespace_1'-large-flavor"}},"spec":{"replicas":1,"selector":{"matchLabels":{"ves.io/workload":"brews-mongodb"}},"template":{"metadata":{"labels":{"ves.io/workload":"brews-mongodb"}},"spec":{"containers":[{"name":"brews-mongodb","image":"public.ecr.aws/o2z6z0t3/friday:demo","resources":{},"terminationMessagePath":"/dev/termination-log","terminationMessagePolicy":"File","imagePullPolicy":"Always"}],"restartPolicy":"Always","terminationGracePeriodSeconds":30,"dnsPolicy":"ClusterFirst","securityContext":{},"schedulerName":"default-scheduler"}},"strategy":{"type":"RollingUpdate","rollingUpdate":{"maxUnavailable":"25%","maxSurge":"25%"}},"revisionHistoryLimit":10,"progressDeadlineSeconds":600}}}'
}

f_mc_mcdp7()
{
s_app_vk8s_name=$v_app_name_1-vk8s
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/vk8s/namespaces/$v_namespace_1/$s_app_vk8s_name/apis/apps/v1/namespaces/$v_namespace_1/deployments" -d '{{"kind":"Deployment","apiVersion":"apps/v1","metadata":{"name":"brews-spa","namespace":"'$v_namespace_1'","annotations":{"ves.io/virtual-sites":"'$v_namespace_1'/'$v_namespace_1'-mcn-vsite","ves.io/workload-flavor-brews-api":"'$v_namespace_1'-large-flavor"}},"spec":{"replicas":1,"selector":{"matchLabels":{"ves.io/workload":"brews-spa"}},"template":{"metadata":{"labels":{"ves.io/workload":"brews-spa"}},"spec":{"containers":[{"name":"brews-spa","image":"f5demos.azurecr.io/spa","env":[{"name":"MONGO_URL","value":"'$v_brews_mongodb_domain'"},{"name":"INVENTORY_URL","value":"http://'$v_brews_inv_domain'"},{"name":"RECOMMENDATIONS_URL","value":"https://'$v_brews_recs_domain'"}],"resources":{},"terminationMessagePath":"/dev/termination-log","terminationMessagePolicy":"File","imagePullPolicy":"Always"}],"restartPolicy":"Always","terminationGracePeriodSeconds":30,"dnsPolicy":"ClusterFirst","securityContext":{},"imagePullSecrets":[{"name":"brews-spa-f5demos"}],"schedulerName":"default-scheduler"}},"strategy":{"type":"RollingUpdate","rollingUpdate":{"maxUnavailable":"25%","maxSurge":"25%"}},"revisionHistoryLimit":10,"progressDeadlineSeconds":600}}}'
}

f_mc_mcdp8()
{
s_app_vk8s_name=$v_app_name_1-vk8s
s_aws1_name=$v_aws1_site_name-vsite
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/vk8s/namespaces/$v_namespace_1/$s_app_vk8s_name/apis/apps/v1/namespaces/$v_namespace_1/deployments" -d '{{"kind":"Deployment","apiVersion":"apps/v1","metadata":{"name":"brews-api","namespace":"'$v_namespace_1'","annotations":{"deployment.kubernetes.io/revision":"1","ves.io/virtual-sites":"'$v_namespace_1'/'$s_aws1_name'","ves.io/workload-flavor-brews-api":"'$v_namespace_1'-large-flavor"}},"spec":{"replicas":1,"selector":{"matchLabels":{"ves.io/workload":"brews-api"}},"template":{"metadata":{"creationTimestamp":null,"labels":{"ves.io/workload":"brews-api"}},"spec":{"containers":[{"name":"brews-api","image":"f5demos.azurecr.io/api","env":[{"name":"MONGO_URL","value":"'$v_brews_mongodb_domain'"},{"name":"INVENTORY_URL","value":"http://'$v_brews_inv_domain'"},{"name":"RECOMMENDATIONS_URL","value":"https://'$v_brews_recs_domain'"}],"resources":{},"terminationMessagePath":"/dev/termination-log","terminationMessagePolicy":"File","imagePullPolicy":"Always"}],"restartPolicy":"Always","terminationGracePeriodSeconds":30,"dnsPolicy":"ClusterFirst","securityContext":{},"imagePullSecrets":[{"name":"brews-api-f5demos"}],"schedulerName":"default-scheduler"}},"strategy":{"type":"RollingUpdate","rollingUpdate":{"maxUnavailable":"25%","maxSurge":"25%"}},"revisionHistoryLimit":10,"progressDeadlineSeconds":600}}}'
}

f_mc_mcdp9()
{
s_app_vk8s_name=$v_app_name_1-vk8s
s_azure1_name=$v_azure1_site_name-vsite
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/vk8s/namespaces/$v_namespace_1/$s_app_vk8s_name/apis/apps/v1/namespaces/$v_namespace_1/deployments" -d '{{"kind":"Deployment","apiVersion":"apps/v1","metadata":{"name":"brews-inv","namespace":"'$v_namespace_1'","annotations":{"ves.io/virtual-sites":"'$v_namespace_1'/'$s_azure1_name'","ves.io/workload-flavor-brews-api":"'$v_namespace_1'-large-flavor"}},"spec":{"replicas":1,"selector":{"matchLabels":{"ves.io/workload":"brews-inv"}},"template":{"metadata":{"creationTimestamp":null,"labels":{"ves.io/workload":"brews-inv"}},"spec":{"containers":[{"name":"brews-inv","image":"f5demos.azurecr.io/inv","env":[{"name":"MONGO_URL","value":"'$v_brews_mongodb_domain'"},{"name":"INVENTORY_URL","value":"http://'$v_brews_inv_domain'"},{"name":"RECOMMENDATIONS_URL","value":"https://'$v_brews_recs_domain'"}],"resources":{},"terminationMessagePath":"/dev/termination-log","terminationMessagePolicy":"File","imagePullPolicy":"Always"}],"restartPolicy":"Always","terminationGracePeriodSeconds":30,"dnsPolicy":"ClusterFirst","securityContext":{},"imagePullSecrets":[{"name":"brews-inv-f5demos"}],"schedulerName":"default-scheduler"}},"strategy":{"type":"RollingUpdate","rollingUpdate":{"maxUnavailable":"25%","maxSurge":"25%"}},"revisionHistoryLimit":10,"progressDeadlineSeconds":600}}}'
}

f_mc_mcdp10()
{
s_app_vk8s_name=$v_app_name_1-vk8s
s_re_name=$v_namespace_1-re-vsite
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/vk8s/namespaces/$v_namespace_1/$s_app_vk8s_name/apis/apps/v1/namespaces/$v_namespace_1/deployments" -d '{{"kind":"Deployment","apiVersion":"apps/v1","metadata":{"name":"brews-recs","namespace":"'$v_namespace_1'","annotations":{"ves.io/virtual-sites":"'$v_namespace_1'/'$s_re_name'","ves.io/workload-flavor-brews-api":"'$v_namespace_1'-large-flavor"}},"spec":{"replicas":1,"selector":{"matchLabels":{"ves.io/workload":"brews-recs"}},"template":{"metadata":{"creationTimestamp":null,"labels":{"ves.io/workload":"brews-recs"}},"spec":{"containers":[{"name":"brews-recs","image":"f5demos.azurecr.io/recs","env":[{"name":"MONGO_URL","value":"'$v_brews_mongodb_domain'"},{"name":"INVENTORY_URL","value":"http://'$v_brews_inv_domain'"},{"name":"RECOMMENDATIONS_URL","value":"https://'$v_brews_recs_domain'"}],"resources":{},"terminationMessagePath":"/dev/termination-log","terminationMessagePolicy":"File","imagePullPolicy":"Always"}],"restartPolicy":"Always","terminationGracePeriodSeconds":30,"dnsPolicy":"ClusterFirst","securityContext":{},"imagePullSecrets":[{"name":"brews-recs-f5demos"}],"schedulerName":"default-scheduler"}},"strategy":{"type":"RollingUpdate","rollingUpdate":{"maxUnavailable":"25%","maxSurge":"25%"}},"revisionHistoryLimit":10,"progressDeadlineSeconds":600}}}'
}

f_mc_mclb1()
{
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$v_namespace_1/healthchecks" -d '{{"metadata":{"name":"brews-mongodb-hc","labels":{}},"spec":{"tcp_health_check":{"send_payload":"abc123"},"timeout":3,"interval":15,"unhealthy_threshold":1,"healthy_threshold":3,"jitter_percent":30},"resource_version":"512132692"}}'
}

f_mc_mclb2()
{
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$v_namespace_1/healthchecks" -d '{{"metadata":{"name":"brews-api-hc","labels":{}},"spec":{"http_health_check":{"use_origin_server_name":{},"path":"/api/stats","use_http2":false,"headers":{},"request_headers_to_remove":[]},"timeout":3,"interval":15,"unhealthy_threshold":1,"healthy_threshold":3,"jitter_percent":30}}
}'
}

f_mc_mclb3()
{
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$v_namespace_1/healthchecks" -d '{{"metadata":{"name":"brews-spa-hc","labels":{}},"spec":{"http_health_check":{"use_origin_server_name":{},"path":"/products","use_http2":false,"headers":{},"request_headers_to_remove":[]},"timeout":3,"interval":15,"unhealthy_threshold":1,"healthy_threshold":3,"jitter_percent":30}}}'
}

f_mc_mclb4()
{
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$v_namespace_1/healthchecks" -d '{"metadata":{"name":"brews-inv-hc","labels":{}},"spec":{"http_health_check":{"use_origin_server_name":{},"path":"/api/stats","use_http2":false,"headers":{},"request_headers_to_remove":[]},"timeout":3,"interval":15,"unhealthy_threshold":1,"healthy_threshold":3,"jitter_percent":30}}'
}

f_mc_mclb5()
{
s_aws2_name=$v_aws2_site_name-vsite
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$v_namespace_1/origin_pools" -d '{"metadata":{"name":"brews-mongodb-pool","namespace":"'$v_namespace_1'","labels":{},"annotations":{},"description":"Brews MCN PoC","disable":false},"spec":{"origin_servers":[{"k8s_service":{"service_name":"brews-mongodb.'$v_namespace_1'","site_locator":{"virtual_site":{"namespace":"'$v_namespace_1'","name":"'$s_aws2_name'","kind":"virtual_site"}},"vk8s_networks":{}},"labels":{}}],"no_tls":{},"port":27017,"same_as_endpoint_port":{},"healthcheck":[{"namespace":"'$v_namespace_1'","name":"brews-mongodb-hc","kind":"healthcheck"}],"loadbalancer_algorithm":"LB_OVERRIDE","endpoint_selection":"LOCAL_PREFERRED"}}'
}

f_mc_mclb6()
{
s_aws1_name=$v_aws1_site_name-vsite
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$v_namespace_1/origin_pools" -d '{"metadata":{"name":"brews-api-pool","namespace":"'$v_namespace_1'","labels":{},"annotations":{},"description":"Brews MCN PoC","disable":false},"spec":{"origin_servers":[{"k8s_service":{"service_name":"brews-api.'$v_namespace_1'","site_locator":{"virtual_site":{"namespace":"'$v_namespace_1'","name":"'$s_aws1_name'","kind":"virtual_site"}},"vk8s_networks":{}},"labels":{}}],"no_tls":{},"port":8000,"same_as_endpoint_port":{},"healthcheck":[{"namespace":"'$v_namespace_1'","name":"brews-api-hc","kind":"healthcheck"}],"loadbalancer_algorithm":"LB_OVERRIDE","endpoint_selection":"LOCAL_PREFERRED"}}'
}

f_mc_mclb7()
{
s_mcn_name=$v_namespace1-vsite
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$v_namespace_1/origin_pools" -d '{"metadata":{"name":"brews-spa-pool","namespace":"'$v_namespace_1'","labels":{},"annotations":{},"description":"Brews MCN PoC","disable":false},"spec":{"origin_servers":[{"k8s_service":{"service_name":"brews-spa.'$v_namespace_1'","site_locator":{"virtual_site":{"namespace":"'$v_namespace_1'","name":"'$s_mcn_name'","kind":"virtual_site"}},"vk8s_networks":{}},"labels":{}}],"no_tls":{},"port":8081,"same_as_endpoint_port":{},"healthcheck":[{"namespace":"'$v_namespace_1'","name":"brews-spa-hc","kind":"healthcheck"}],"loadbalancer_algorithm":"LB_OVERRIDE","endpoint_selection":"LOCAL_PREFERRED"}}'
}

f_mc_mclb8()
{
s_azure1_name=$v_azure1_name-vsite
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$v_namespace_1/origin_pools" -d '{"metadata":{"name":"brews-inv-pool","namespace":"'$v_namespace_1'","labels":{},"annotations":{},"description":"Brews MCN PoC","disable":false},"spec":{"origin_servers":[{"k8s_service":{"service_name":"brews-inv.'$v_namespace_1'","site_locator":{"virtual_site":{"namespace":"'$v_namespace_1'","name":"'$s_azure1_name'","kind":"virtual_site"}},"vk8s_networks":{}},"labels":{}}],"no_tls":{},"port":8002,"same_as_endpoint_port":{},"healthcheck":[{"namespace":"'$v_namespace_1'","name":"brews-inv-hc","kind":"healthcheck"}],"loadbalancer_algorithm":"LB_OVERRIDE","endpoint_selection":"LOCAL_PREFERRED"}}'
}

f_mc_mclb9()
{
s_aws1_name=$v_aws1_site_name-vsite
s_aws2_name=$v_aws2_site_name-vsite
s_azure1_name=$v_azure1_site_name-vsite
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$v_namespace_1/tcp_loadbalancers" -d '{"metadata":{"name":"brews-mongodb-tcp-lb","namespace":"'$v_namespace_1'","labels":{},"annotations":{},"description":"Brews MCN PoC","disable":false},"spec":{"domains":["'$v_brews_mondodb_domain'"],"listen_port":27017,"no_sni":{},"dns_volterra_managed":false,"origin_pools":[],"origin_pools_weights":[{"pool":{"namespace":"'$v_namespace_1'","name":"brews-mongodb-pool","kind":"origin_pool"},"weight":1,"priority":1,"endpoint_subsets":{}}],"advertise_custom":{"advertise_where":[{"virtual_site":{"network":"SITE_NETWORK_SERVICE","virtual_site":{"namespace":"'$v_namespace_1'","name":"'$s_aws1_site_name'","kind":"virtual_site"}},"use_default_port":{}},{"virtual_site":{"network":"SITE_NETWORK_SERVICE","virtual_site":{"namespace":"'$v_namespace_1'}","name":"'$s_azure1_name'","kind":"virtual_site"}},"use_default_port":{}},{"virtual_site":{"network":"SITE_NETWORK_SERVICE","virtual_site":{"namespace":"'$v_namespace_1'","name":"'$s_aws2_name'","kind":"virtual_site"}},"use_default_port":{}}]},"hash_policy_choice_round_robin":{},"idle_timeout":3600000,"retract_cluster":{},"tcp":{},"dns_info":[],"downstream_tls_certificate_expiration_timestamps":[]}}'
}

f_mc_mclb10()
{
s_aws1_name=$v_aws1_site_name-vsite
s_aws2_name=$v_aws2_site_name-vsite
s_azure1_name=$v_azure1_site_name-vsite
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$v_namespace_1/http_loadbalancers" -d '{"metadata":{"name":"brews-inv-http-lb","labels":{},"description":"Brews PoC MCN"},"spec":{"domains":["'$v_brews_inc_domain'"],"http":{"dns_volterra_managed":false,"port":80},"advertise_custom":{"advertise_where":[{"virtual_site":{"network":"SITE_NETWORK_SERVICE","virtual_site":{"namespace":"'$v_namespace_1'","name":"'$s_aws1_site_name'","kind":"virtual_site"}},"use_default_port":{}},{"virtual_site":{"network":"SITE_NETWORK_SERVICE","virtual_site":{"namespace":"'$v_namespace_1'","name":"'$s_azure1_name'","kind":"virtual_site"}},"use_default_port":{}},{"virtual_site":{"network":"SITE_NETWORK_SERVICE","virtual_site":{"namespace":"'$v_namespace_1'","name":"'$s_aws2_name'","kind":"virtual_site"}},"use_default_port":{}}]},"default_route_pools":[{"pool":{"namespace":"'$v_namespace_1'","name":"brews-inv-pool","kind":"origin_pool"},"weight":1,"priority":1,"endpoint_subsets":{}}],"routes":[],"disable_waf":{},"add_location":false,"no_challenge":{},"user_id_client_ip":{},"disable_rate_limit":{},"waf_exclusion_rules":[],"data_guard_rules":[],"blocked_clients":[],"trusted_clients":[],"ddos_mitigation_rules":[],"service_policies_from_namespace":{},"cookie_stickiness":{"name":"brews-inv"},"multi_lb_app":{},"disable_bot_defense":{},"disable_api_definition":{},"disable_ip_reputation":{}}}'
}

f_mc_mclb11()
{
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$v_namespace_1/http_loadbalancers" -d '{"metadata":{"name":"brews-shop-spa-http-lb","labels":{},"description":"brews MCN PoC"},"spec":{"domains":["'$v_brews_spa_momain'"],"https":{"http_redirect":null,"add_hsts":null,"tls_parameters":{"tls_config":{"default_security":{}},"tls_certificates":[{"certificate_url":"string:///{{base64EncodedCert}}","private_key":{"clear_secret_info":{"url":"string:///{{base64EncodedKey}}","provider":null},"blindfold_secret_info_internal":null,"secret_encoding_type":"EncodingNone"},"description":null}],"no_mtls":{}},"default_header":{}},"advertise_on_public_default_vip":{},"default_route_pools":[{"pool":{"namespace":"'$v_namespace_1'","name":"brews-spa-pool","kind":"origin_pool"},"weight":1,"priority":1,"endpoint_subsets":{}}],"routes":[{"simple_route":{"http_method":"ANY","path":{"prefix":"/api/"},"origin_pools":[{"pool":{"namespace":"'$v_namespace_1'","name":"brews-api-pool","kind":"origin_pool"},"weight":1,"priority":1,"endpoint_subsets":{}}],"headers":[],"auto_host_rewrite":{}}},{"simple_route":{"http_method":"ANY","path":{"prefix":"/images/"},"origin_pools":[{"pool":{"namespace":"'$v_namespace_1'","name":"brews-api-pool","kind":"origin_pool"},"weight":1,"priority":1,"endpoint_subsets":{}}],"headers":[],"auto_host_rewrite":{}}}],"app_firewall":{"namespace":"'$v_namespace_1'","name":"brews-spa-api-appwf","kind":"app_firewall"},"add_location":true,"no_challenge":{},"user_id_client_ip":{},"disable_rate_limit":{},"waf_exclusion_rules":[],"data_guard_rules":[],"blocked_clients":[],"trusted_clients":[],"ddos_mitigation_rules":[],"service_policies_from_namespace":{},"round_robin":{},"disable_trust_client_ip_headers":{},"enable_ddos_detection":{},"enable_malicious_user_detection":{},"enable_api_discovery":{"enable_learn_from_redirect_traffic":{}},"disable_bot_defense":{},"disable_api_definition":{},"disable_ip_reputation":{}}}'
}

f_mc_mclb12()
{
s_key="$v_namespace_1-key"
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$v_namespace_1/http_loadbalancers" -d '{"metadata":{"name":"brews-shop-spa-http-lb","labels":{},"description":"brews MCN PoC"},"spec":{"domains":["'$v_brews_spa_momain'"],"https":{"http_redirect":null,"add_hsts":null,"tls_parameters":{"tls_config":{"default_security":{}},"tls_certificates":[{"certificate_url":"string:///{{base64EncodedCert}}","private_key":{"blindfold_secret_info":{"location":"string:///'$s_key'","decryption_provider":null,"store_provider":null},"blindfold_secret_info_internal":null,"secret_encoding_type":null},"description":null}],"no_mtls":{}},"default_header":{}},"advertise_on_public_default_vip":{},"default_route_pools":[{"pool":{"namespace":"'$v_namespace_1'","name":"brews-spa-pool","kind":"origin_pool"},"weight":1,"priority":1,"endpoint_subsets":{}}],"routes":[{"simple_route":{"http_method":"ANY","path":{"prefix":"/api/"},"origin_pools":[{"pool":{"namespace":"'$v_namespace_1'","name":"brews-api-pool","kind":"origin_pool"},"weight":1,"priority":1,"endpoint_subsets":{}}],"headers":[],"auto_host_rewrite":{}}},{"simple_route":{"http_method":"ANY","path":{"prefix":"/images/"},"origin_pools":[{"pool":{"namespace":"'$v_namespace_1'","name":"brews-api-pool","kind":"origin_pool"},"weight":1,"priority":1,"endpoint_subsets":{}}],"headers":[],"auto_host_rewrite":{}}}],"app_firewall":{"namespace":"'$v_namespace_1'","name":"brews-spa-api-appwf","kind":"app_firewall"},"add_location":true,"no_challenge":{},"user_id_client_ip":{},"disable_rate_limit":{},"waf_exclusion_rules":[],"data_guard_rules":[],"blocked_clients":[],"trusted_clients":[],"ddos_mitigation_rules":[],"service_policies_from_namespace":{},"round_robin":{},"disable_trust_client_ip_headers":{},"enable_ddos_detection":{},"enable_malicious_user_detection":{},"enable_api_discovery":{"enable_learn_from_redirect_traffic":{}},"disable_bot_defense":{},"disable_api_definition":{},"disable_ip_reputation":{}}}'
}

f_mc_mclb13()
{
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$v_namespace_1/http_loadbalancers" -d '{"metadata":{"name":"brews-shop-spa-http-lb","labels":{},"description":"brews MCN PoC"},"spec":{"domains":["'$v_brews_spa_domain'"],"https_auto_cert":{"http_redirect":true,"add_hsts":true,"port":443,"tls_config":{"default_security":{}},"no_mtls":{},"default_header":{},"enable_path_normalize":{},"non_default_loadbalancer":{}},"advertise_on_public_default_vip":{},"default_route_pools":[{"pool":{"namespace":"'$v_namespace_1'","name":"brews-spa-pool","kind":"origin_pool"},"weight":1,"priority":1,"endpoint_subsets":{}}],"routes":[{"simple_route":{"http_method":"ANY","path":{"prefix":"/api/"},"origin_pools":[{"pool":{"namespace":"'$v_namespace_1'","name":"brews-api-pool","kind":"origin_pool"},"weight":1,"priority":1,"endpoint_subsets":{}}],"headers":[],"auto_host_rewrite":{}}},{"simple_route":{"http_method":"ANY","path":{"prefix":"/images/"},"origin_pools":[{"pool":{"namespace":"'$v_namespace_1'","name":"brews-api-pool","kind":"origin_pool"},"weight":1,"priority":1,"endpoint_subsets":{}}],"headers": [],"auto_host_rewrite":{}}}],"app_firewall":{"namespace":"'$v_namespace_1'","name":"brews-spa-api-appwf","kind":"app_firewall"},"add_location":true,"no_challenge":{},"user_id_client_ip":{},"disable_rate_limit":{},"waf_exclusion_rules":[],"data_guard_rules":[],"blocked_clients":[],"trusted_clients":[],"ddos_mitigation_rules":[],"service_policies_from_namespace":{},"round_robin":{},"disable_trust_client_ip_headers":{},"enable_ddos_detection":{},"enable_malicious_user_detection":{},"enable_api_discovery":{"enable_learn_from_redirect_traffic":{}},"disable_bot_defense":{},"disable_api_definition":{},"disable_ip_reputation":{}}}'
}

f_mc_mclb14()
{
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/$v_namespace_1/http_loadbalancers" -d '{"metadata":{"name": "brews-shop-spa-http-lb","labels":{},"description":"brews MCN PoC"},"spec":{"domains":["'$v_brews_spa_domain'"],"http":{"dns_volterra_managed":true,"port":80},"advertise_on_public_default_vip":{},"default_route_pools":[{"pool":{"namespace":"'$v_namespace_1'","name":"brews-spa-pool","kind":"origin_pool"},"weight":1,"priority":1,"endpoint_subsets":{}}],"routes":[{"simple_route":{"http_method":"ANY","path":{"prefix":"/api/"},"origin_pools":[{"pool":{"namespace":"'$v_namespace_1'","name":"brews-api-pool","kind":"origin_pool"},"weight":1,"priority":1,"endpoint_subsets":{}}],"headers":[],"auto_host_rewrite":{}}},{"simple_route":{"http_method":"ANY","path":{"prefix":"/images/"},"origin_pools":[{"pool":{"namespace":"'$v_namespace_1'","name":"brews-api-pool","kind":"origin_pool"},"weight":1,"priority":1,"endpoint_subsets":{}}],"headers":[],"auto_host_rewrite":{}}}],"app_firewall":{"namespace":"'$v_namespace_1'","name":"brews-spa-api-appwf","kind":"app_firewall"},"add_location": true,"no_challenge":{},"user_id_client_ip":{},"disable_rate_limit":{},"waf_exclusion_rules":[],"data_guard_rules":[],"blocked_clients":[],"trusted_clients":[],"ddos_mitigation_rules":[],"service_policies_from_namespace":{},"round_robin":{},"disable_trust_client_ip_headers":{},"enable_ddos_detection":{},"enable_malicious_user_detection":{},"enable_api_discovery":{"enable_learn_from_redirect_traffic":{}},"disable_bot_defense":{},"disable_api_definition":{},"disable_ip_reputation":{}}}'
}

### main

f_echo "F5 Training $product_name script Version $script_ver"

if [ $# -eq 0 ]; then
f_usage
fi

if [ "$#" != 2 ]; then
 f_echo "Missing student name ... "
 exit 1
fi

snumdigits=`echo $2 | wc -m`
if [ $snumdigits -eq 11 ]; then
 snum=`echo -n $2 | tail -c 3`
elif
 [ $snumdigits -eq 10 ]; then
 snum=`echo -n $2 | tail -c 2`
else
 snum=`echo -n $2 | tail -c 1`
fi

### Adjusting vars depending on command lne inputs

echo "Setting variables from input ..."
echo "Student name: $2"
echo "Student number: $snum"

v_aws1_site_name="$2-vpc1"
v_aws2_site_name="$2-vpc2"
v_azure1_site_name="$2-vnet1"
v_aws1_key1="$2-key"
v_aws1_key1_value="$2-value1"
v_aws2_key1="$2-key"
v_aws2_key1_value="$2-value2"
v_key2="$2brews-sites"
v_key2_value="all-sites"
v_aws1_key3="ves.io/siteName"
v_aws2_key3="ves.io/siteName"
v_aws2_key3_value="$2-vpc1"
v_aws2_key3_value="$2-vpc2"
v_namespace_1="$2-brews"
v_app_name_1="brews$snum"
v_brews_spa_domain="brews$snum.aws.learnf5.cloud"
v_brews_recs_domain="recs$snum.aws.learnf5.cloud"
v_brews_inv_domain="inventory$snum.brews.local"
v_brews_mongodb_domain="mongodb$snum.brews.local"

while [ $# -gt 0 ]; do
 case "$1" in
   -sa)
   f_echo "Testing F5XC API token ..."
   f_test_token
   ;;
   -sb)
   f_echo "Printing variables ..."
   f_print_vars
   ;;
   -a1)
   f_echo "Creating AWS VPC site 1 called $v_aws1_site_name ..."
   f_mc_a1
   ;;
   -a2)
   f_echo "Creating AWS VPC site 2 called $v_aws2_site_name ..."
   f_mc_a2
   ;;
   -a3)
   f_echo "Creating Azure VNET site 1 called $v_azure1_site_name ..."
   f_mc_a3
   ;;
   -s1)
   f_echo "Checking AWS1 cloud site status ..."
   echo $v_aws1_site_name
   f_mc_s1
   ;;
   -s2)
   f_echo "Checking AWS2 cloud site status ..."
   f_mc_s2
   ;;
   -s3)
   f_echo "Checking Azure1 cloud site status ..."
   f_mc_s3
   ;;
   -s4)
   f_echo "Creating namespace 1 called $v_namespace_1 ..."
   f_mc_s4
   ;;
   -s5)
   f_echo "Creating MCN label key ..."
   f_mc_s5
   ;;
   -s6)
   f_echo "Creating MCN label ..."
   f_mc_s6
   ;;
   -s7)
   f_echo "Creating Brews workload ..."
   f_mc_s7
   ;;
   -s8)
   f_echo "Creating SPA WAF ..."
   f_mc_s8
   ;;
   -s9 | -mccvs)
   f_echo "Creating MCN vsite ..."
   f_mc_mccvs
   ;;
   -s10 | -mccre)
   f_echo "Creating RE only vsite ..."
   f_mc_mccre
   ;;
   -s11 | -mccaz)
   f_echo "Creating Azure 1 vsite ..."
   f_mc_mccaz
   ;;
   -s12 | -mccaz)
   f_echo "Creating AWS 1 vsite ..."
   f_mc_mcca1
   ;;
   -s13 | -mccaz)
   f_echo "Creating AWS 2 vsite ..."
   f_mc_mcca2
   ;;
   -s14 | -mccvk)
   f_echo "Creating vK8s cluster ..."
   f_mc_mccvk
   ;;
   -s15 | -mcgvk)
   f_echo "Geting vK8s cluster status ..."
   f_mc_mcgvk
   ;;
   -s16 | -mcwl1)
   f_echo "Creating container registry ..."
   f_mc_mcwl1
   ;;
   -s17 | -mcwl2)
   f_echo "Deploy Mongodb ..."
   f_mc_mcwl2
   ;;
   -s18 | -mcwl3)
   f_echo "Deploy SPA ..."
   f_mc_mcwl3
   ;;
   -s19 | -mcwl4)
   f_echo "Deploy API ..."
   f_mc_mcwl4
   ;;
   -s20 | -mcwl5)
   f_echo "Deploy Inventory ..."
   f_mc_mcwl5
   ;;
   -s21 | -mcwl6)
   f_echo "Deploy Recommendations HTTP LB manual cert cleartext ..."
   f_mc_mcwl6
   ;;
   -s22 | -mcwl7)
   f_echo "Deploy Recommendations HTTP LB manual cert blindfold ..."
   f_mc_mcwl7
   ;;
   -s23 | -mcwl8)
   f_echo "Deploy Recommendations HTTP LB auto cert ..."
   f_mc_mcwl8
   ;;
   -s24 | -mcwl9)
   f_echo "Deploy Recommendations HTTP LB ..."
   f_mc_mcwl9
   ;;
   -s25 | -mcdp1)
   f_echo "Delete Recommendations ..."
   f_mc_mcdp1
   ;;
   -s26 | -mcdp2)
   f_echo "Delete Inventory ..."
   f_mc_mcdp2
   ;;
   -s27 | -mcdp3)
   f_echo "Delete API ..."
   f_mc_mcdp3
   ;;
   -s28 | -mcdp4)
   f_echo "Delete SPA ..."
   f_mc_mcdp4
   ;;
   -s29 | -mcdp5)
   f_echo "Delete Mongodb ..."
   f_mc_mcdp5
   ;;
   -s30 | -mcdp6)
   f_echo "Deploy Mongodb ..."
   f_mc_mcdp6
   ;;
   -s31 | -mcdp7)
   f_echo "Deploy SPA ..."
   f_mc_mcdp7
   ;;
   -s32 | -mcdp8)
   f_echo "Deploy API ..."
   f_mc_mcdp8
   ;;
   -s33 | -mcdp9)
   f_echo "Deploy Inventory ..."
   f_mc_mcdp9
   ;;
   -s34 | -mcdp10)
   f_echo "Deploy Recommendations ..."
   f_mc_mcdp10
   ;;
   -s35 | -mclb1)
   f_echo "Create Mongodb healthcheck ..."
   f_mc_mcdp1
   ;;
   -s36 | -mclb2)
   f_echo "Create API healthcheck ..."
   f_mc_mcdp2
   ;;
   -s37 | -mclb3)
   f_echo "Create SPA healthcheck ..."
   f_mc_mcdp3
   ;;
   -s38 | -mclb4)
   f_echo "Create INV healthcheck ..."
   f_mc_mcdp4
   ;;
   -s39 | -mclb5)
   f_echo "Create Mongodb origin pool ..."
   f_mc_mcdp5
   ;;
   -s40 | -mclb6)
   f_echo "Create API origin pool ..."
   f_mc_mcdp6
   ;;
   -s41 | -mclb7)
   f_echo "Create SPA origin pool ..."
   f_mc_mcdp7
   ;;
   -s42 | -mclb8)
   f_echo "Create INV origin pool ..."
   f_mc_mcdp8
   ;;
   -s43 | -mclb9)
   f_echo "Create Mongodb TCP load balancer (internal) ..."
   f_mc_mcdp9
   ;;
   -s44 | -mclb10)
   f_echo "Create INV HTTP load balancer (internal) ..."
   f_mc_mcdp10
   ;;
   -s45 | -mclb11)
   f_echo "Create SPA-API HTTPS lb (public manual cert cleartext) ..."
   f_mc_mcdp11
   ;;
   -s46 | -mclb12)
   f_echo "Create SPA-API HTTPS lb (public manual cert blindfold) ..."
   f_mc_mcdp12
   ;;
   -s47 | -mclb13)
   f_echo "Create SPA-API HTTPS lb (public autocert) ..."
   f_mc_mcdp13
   ;;
   -s48 | -mclb14)
   f_echo "Create SPA-API HTTPS lb (public) ..."
   f_mc_mcdp14
   ;;
   *)
   ;;
 esac
 shift
done
f_echo "End ..."
