#!/bin/bash

### variables

product_name="F5 Distributed Cloud"
script_ver="1.0"
script_name="mc.sh"
student_name=$2

v_tenant="training-dev-fcphvhww"
v_dom="dev.learnf5.cloud"
v_aws_creds_name="learnf5-aws"
v_azu_creds_name="all-students-credentials"

v_token="oGYFFHzhM0iLQKkQ9TK5y3N0/xA="
v_url="https://training-dev.console.ves.volterra.io/api"
v_aws1_site_name="student99-vpc1"
v_aws2_site_name="student99-vpc2"
v_azure1_site_name="student99-vnet1"
v_namespace_1="student99-brews"
v_app_name_1="brews99"
v_brews_spa_domain="brews99.learnf5.cloud"
v_brews_recs_domain="recs99.learnf5.cloud"
v_brews_inv_domain="inventory99.brews.local"
v_brews_mongodb_domain="mongodb99.brews.local"
v_namespace_1_cert="abcd"
v_namespace_1_key="bcd"
v_use_https="no"
v_use_autocert="yes"

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
echo "Cloud Site Status"
echo ""
echo "-tok                       Test token"
echo "-mcs1                      AWS site 1 status"
echo "-mcs2                      AWS site 2 status"
echo "-mcs3                      Azure site 1 status"
echo ""
echo "Base Configuration"
echo ""
echo "vK8s and vsites"
echo ""
echo "Workloads"
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
   -mcs1)
   f_echo "Checking AWS1 cloud site status ..."
   f_mc_mcs1
   ;;
   -mcs2)
   f_echo "Checking AWS2 cloud site status ..."
   f_mc_mcs2
   ;;
   -mcs3)
   f_echo "Checking Azure1 cloud site status ..."
   f_mc_mcs3
   ;;
   *)
   ;;
 esac
 shift
done
f_echo "End ..."
