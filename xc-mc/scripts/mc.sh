#!/bin/bash

### variables

product_name="F5 Distributed Cloud"
script_ver="1.0"
script_name="mc.sh"
student_name=$2

v_tenant="training-dev-fcphvhww"
v_dom="dev.learnf5.cloud"
### Adjust to whatever tenant and DNS domain in use
### v_dom="learnf5.cloud"
v_aws_creds_name="learnf5-aws"
v_azu_creds_name="all-students-credentials"

v_token="oGYFFHzhM0iLQKkQ9TK5y3N0/xA="
v_url="https://training-dev.console.ves.volterra.io/api"
v_aws1_site_name="student99-vpc1"
v_aws2_site_name="student99-vpc2"
v_azure1_site_name="student99-vnet1"
v_namespace_1="student99-brews"
v_app_name_1="brews99"
### Adjust to whatever tenant and DNS domain in use
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
echo "-sa -tok                       Test token"
echo ""
echo "Cloud Site Status"
echo ""
echo "-s1 -mcs1                      AWS site 1 status"
echo "-s2 -mcs2                      AWS site 2 status"
echo "-s3 -mcs3                      Azure site 1 status"
echo ""
echo "Base Configuration"
echo ""
echo "-s4 -mccn                      Create namespace 1"
echo "-s5 -mcke                      Create MCN label key"
echo "-s6 -mcla                      Create MCN label"
echo "-s7 -mcwlk                     Create Brews workload"
echo "-s8 -mcwaf                     Create SPA WAF"
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
echo "Load Balancing and WAAP"
echo ""
exit 0
}

f_test_token()
{
curl -s -X GET -H "Authorization: APIToken $v_token" $v_url/web/namespaces | jq
}

f_mc_mcs1()
{
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/system/aws_vpc_sites/$aws1_site_name" | jq
}

f_mc_mcs2()
{
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/system/aws_vpc_sites/$aws2_site_name" | jq
}

f_mc_mcs3()
{
curl -s -H "Authorization: APIToken $v_token" -X GET "$v_url/config/namespaces/system/aws_vpc_sites/$azure1_site_name" | jq
}

f_mc_mccn()
{
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/web/namespaces" -d '{"metadata":{"name":"'$v_namespace_1'"},"spec":{}}' | jq
sleep 1
}

f_mc_mcke()
{
s_key=$v_app_name_1-sites
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/shared/known_label_key/create" -d '{"key":"'$s_key'","namespace":"shared"}'
}

f_mc_mcla()
{
s_key=$v_app_name_1-sites
s_value="all-sites"
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/shared/known_label/create" -d '{"key":"'$s_key'","namespace":"shared","value":"'$s_value'"}'
}

f_mc_mcwlk()
{
s_wl_flavor=$v_namespace_1-large-flavor
curl -s -H "Authorization: APIToken $v_token" -X POST "$v_url/config/namespaces/shared/workload_flavors" -d '{"metadata":{"name":"'$s_wl_flavor'","namespace":"shared"},"spec":{"memory":"512","vcpus":0.25,"ephemeral_storage":"0"}}'
}

f_mc_mcwaf()
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
s_aws2_name=$v_aws2_site_name-vsite
}

f_mc_mcwl5()
{
s_aws2_name=$v_aws2_site_name-vsite
}

f_mc_mcwl6()
{
s_aws2_name=$v_aws2_site_name-vsite
}

f_mc_mcwl7()
{
s_aws2_name=$v_aws2_site_name-vsite
}

f_mc_mcwl8()
{
s_aws2_name=$v_aws2_site_name-vsite
}

f_mc_mcwl9()
{
s_aws2_name=$v_aws2_site_name-vsite
}

### main

f_echo "F5 Training $product_name script Version $script_ver"

if [ $# -eq 0 ]; then
f_usage
fi

while [ $# -gt 0 ]; do
 case "$1" in
   -sa | -tok)
   f_test_token
   ;;
   -s1 | -mcs1)
   f_echo "Checking AWS1 cloud site status ..."
   f_mc_mcs1
   ;;
   -s2 | -mcs2)
   f_echo "Checking AWS2 cloud site status ..."
   f_mc_mcs2
   ;;
   -s3 | -mcs3)
   f_echo "Checking Azure1 cloud site status ..."
   f_mc_mcs3
   ;;
   -s4 | -mccn)
   f_echo "Creating namespace 1 ..."
   f_mc_mcs3
   ;;
   -s5 | -mcke)
   f_echo "Creating MCN label key ..."
   f_mc_mcke
   ;;
   -s6 | -mcla)
   f_echo "Creating MCN label ..."
   f_mc_mcke
   ;;
   -s7 | -mcwlk)
   f_echo "Creating Brews workload ..."
   f_mc_mcwlk
   ;;
   -s8 | -mcwaf)
   f_echo "Creating SPA WAF ..."
   f_mc_mcwaf
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
   *)
   ;;
 esac
 shift
done
f_echo "End ..."
