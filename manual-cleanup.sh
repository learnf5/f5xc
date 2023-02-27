#!/bin/bash
# set -e 

## for token info view https://docs.cloud.f5.com/docs/how-to/user-mgmt/credentials

## P12 curl
# curl -s -X     https://$VOLTERRA_TENANT/api/web/namespaces --cert-type P12 --cert $P12_FILE:$VES_P12_PASSWORD | jq .

## with token
# curl -k -X GET https://$VOLTERRA_TENANT/api/web/namespaces -H "Authorization: APIToken $VOLTERRA_TOKEN" | jq . 

# VOLTERRA_TOKEN="foobar"
# api_url="https://playground.console.ves.volterra.io/api"

VOLTERRA_TOKEN=$1
api_url=$2

#### MAIN ####
ns_cleanup_list="$(curl -s -X GET -H "Authorization: APIToken $VOLTERRA_TOKEN" $api_url/web/namespaces | jq -r .[][].name |grep -E 'student[1-9]{1}')"

echo "Namespaces:"
echo $ns_cleanup_list
sleep 1


read -n 1 -p "Do you want to delete the namespaces listed above (y or n):" mainmenuinput
echo
if [ "$mainmenuinput" = "y" ]; then

  for namespace in $ns_cleanup_list; do
    echo
    echo "=== CASCADE DELETE $namespace ==="

    # see "Step 3: Generate and download certificate."
    # https://docs.cloud.f5.com/docs/how-to/user-mgmt/credentials
    curl -k  -X POST -H "Authorization: APIToken $VOLTERRA_TOKEN" \
      "$api_url/web/namespaces/$namespace/cascade_delete"

    sleep 1
  done
fi

site_cleanup_list="$(curl -s -X GET -H "Authorization: APIToken $VOLTERRA_TOKEN" $api_url/config/namespaces/system/sites | jq -r .[][].name |grep -E 'student[1-9]{1}')"

echo "Sites:"
echo $site_cleanup_list
sleep 1

echo
read -n 1 -p "Do you want to delete the sites listed above (y or n):" mainmenuinput
echo
if [ "$mainmenuinput" = "y" ]; then
  for site_name in "$site_cleanup_list"; do
    echo
    echo "=== DECOMMISSIONING $site_name ==="

    curl -X 'DELETE' -s \
      -H "Authorization: APIToken $VOLTERRA_TOKEN" \
      "$api_url/config/namespaces/system/aws_vpc_sites/$site_name"
    sleep 1

    ## if you want to delete azure sites then use the command below, 
    ## probably with an if statement or a new loop would be a good place for it so the script knows what to delete
    # curl -X 'DELETE' -s \
    #   -H "Authorization: APIToken $VOLTERRA_TOKEN"
    #   "$api_url/config/namespaces/system/azure_vnet_sites/$site_name"
  done
fi

label_cleanup_list="$(curl -s -X GET \
                      -H "Authorization: APIToken $VOLTERRA_TOKEN" \
                      "$api_url/config/namespaces/shared/known_labels?key=&namespace=shared&query=QUERY_ALL_LABELS&value=" \
                      | jq -r .label[].value \
                      |grep -E 'student[1-9]{1}' 
                    )"

echo "labels:"
echo $label_cleanup_list
sleep 1

echo
read -n 1 -p "Do you want to delete the labels listed above (y or n):" mainmenuinput
echo
if [ "$mainmenuinput" = "y" ]; then
  for label_name in $label_cleanup_list; do
    echo
    echo "=== DECOMMISSIONING $label_name ==="

    key_name=$(curl -s -X GET \
                -H "Authorization: APIToken $VOLTERRA_TOKEN" \
                "$api_url/config/namespaces/shared/known_labels?key=&namespace=shared&query=QUERY_ALL_LABELS&value=" \
                | jq -r ".label[] | select(.\"value\"==\"$label_name\") | .key" 
              )

    curl -X 'POST' -s \
      -H "Authorization: APIToken $VOLTERRA_TOKEN" \
      -d "{\"namespace\":\"shared\", \"value\":\"$label_name\",\"key\":\"$key_name\"}" \
      "$api_url/config/namespaces/shared/known_label/delete"

    sleep 1
  done
fi


key_cleanup_list="$(curl -s -X GET \
                      -H "Authorization: APIToken $VOLTERRA_TOKEN" \
                      "$api_url/config/namespaces/shared/known_label_keys?key=&namespace=shared&query=QUERY_ALL_LABEL_KEYS" \
                      | jq -r .label_key[].key \
                      |grep -E 'student[1-9]{1}')"

echo "keys:"
echo $key_cleanup_list
sleep 1

echo
read -n 1 -p "Do you want to delete the creds listed above (y or n):" mainmenuinput
echo
if [ "$mainmenuinput" = "y" ]; then
  for key_name in $key_cleanup_list; do
    echo
    echo "=== DECOMMISSIONING $key_name ==="

    curl -X 'POST' -s \
      -H "Authorization: APIToken $VOLTERRA_TOKEN" \
      -d "{\"namespace\":\"shared\",\"key\":\"$key_name\"}" \
      "$api_url/config/namespaces/shared/known_label_key/delete"
    sleep 1
  done
fi

