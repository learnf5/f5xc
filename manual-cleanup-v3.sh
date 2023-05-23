#!/usr/bin/bash
# set -e 

#if [ "$#" -ne 2 ]; then
#    echo "Illegal number of parameters"
#    echo "APIToken consoleURL"
#    exit 1
#fi

VOLTERRA_TOKEN="Kv5+6IJm1ee04aJ3/PjzlA3ffi0="
api_url="https://training.console.ves.volterra.io/api"

##NAMESPACES
#ns_cleanup_list="$(curl -s -X GET -H "Authorization: APIToken $VOLTERRA_TOKEN" $api_url/api/web/namespaces | jq -r .[][].name |grep -E 'student[1-9]{1}')"
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

## SITES
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

## LABELS
label_cleanup_list="$(curl -s -X GET \
                      -H "Authorization: APIToken $VOLTERRA_TOKEN" \
                      "$api_url/config/namespaces/shared/known_labels?key=&namespace=shared&query=QUERY_ALL_LABELS&value=" \
                      | jq -r .label[].value \
                      |grep -E 'student[1-9]{1}')"

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

## KEYS
key_cleanup_list="$(curl -s -X GET \
                      -H "Authorization: APIToken $VOLTERRA_TOKEN" \
                      "$api_url/config/namespaces/shared/known_label_keys?key=&namespace=shared&query=QUERY_ALL_LABEL_KEYS" \
                      | jq -r .label_key[].key \
                      |grep -E 'student[1-9]{1}')"

echo "keys:"
echo $key_cleanup_list
sleep 1

echo
read -n 1 -p "Do you want to delete the keys listed above (y or n):" mainmenuinput
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

## VSITES 
vsite_cleanup_list="$(curl -s -X GET \
                      -H "Authorization: APIToken $VOLTERRA_TOKEN" \
                      "$api_url/config/namespaces/shared/virtual_sites" \
                      | jq -r .[][].name \
                      |grep -E 'student[1-9]{1}')"

echo "Virtual Sites:"
echo  "$vsite_cleanup_list"
sleep 1
echo
read -n 1 -p "Do you want to delete the virtual sites listed above (y or n):" mainmenuinput
echo

if [ "$mainmenuinput" = "y" ]; then
  for vsite_name in $vsite_cleanup_list; do
    echo
    echo "=== DECOMMISSIONING $vsite_name ==="
    curl -X 'DELETE' -s\
      -H "Authorization: APIToken $VOLTERRA_TOKEN"\
      "$api_url/config/namespaces/shared/virtual_sites/$vsite_name"; 
    sleep 1
    done
fi

## API CREDS
api_creds_cleanup_list="$(curl -s -X GET \
                      -H "Authorization: APIToken $VOLTERRA_TOKEN" \
                      "$api_url/web/namespaces/system/api_credentials" \
                       | jq -r .[][].name \
                       |grep -E 'student[1-9]{1}')"



echo "API Credentials:"
echo  "$api_creds_cleanup_list"
sleep 1
echo
read -n 1 -p "Do you want to revoke the API Credentials listed above (y or n):" mainmenuinput
echo

if [ "$mainmenuinput" = "y" ]; then
  for api_cred in $api_creds_cleanup_list; do
    echo
    echo "=== REVOKING $api_cred ==="
    curl -X 'POST' -s\
      -H "Authorization: APIToken $VOLTERRA_TOKEN" \
        "$api_url/web/namespaces/system/revoke/api_credentials" \
      -d '{
            "name": "'$api_cred'",
            "namespace": "system"
          }'; 
    sleep 1
    done
fi

## ALERT RECEIVERS
alert_receivers_cleanup_list="$(curl -s -X GET \
                            -H "Authorization: APIToken $VOLTERRA_TOKEN" \
                            "$api_url/config/namespaces/system/alert_receivers" \
                            | jq -r .[][].name \
                            |grep -E 'student[1-9]{1}')"

echo "Alert Receivers:"
echo  "$alert_receivers_cleanup_list"
sleep 1
echo
read -n 1 -p "Do you want to revoke the Alert Receivers listed above (y or n):" mainmenuinput
echo

if [ "$mainmenuinput" = "y" ]; then
  for alert_receiver in $alert_receivers_cleanup_list; do
    echo
    echo "=== DECOMMISSIONING $alert_receiver ==="
    curl -X 'DELETE' -s\
      -H "Authorization: APIToken $VOLTERRA_TOKEN"\
      "$api_url/config/namespaces/shared/alert_receivers/$alert_receiver"; 
    sleep 1
    done
fi

## ALERT RECEIVERS
alert_policies_cleanup_list="$(curl -s -X GET \
                            -H "Authorization: APIToken $VOLTERRA_TOKEN" \
                            "$api_url/config/namespaces/shared/alert_policys" \
                            | jq -r .[][].name \
                            |grep -E 'student[1-9]{1}')"
echo "Alert Policies:"
echo  "$alert_policies_cleanup_list"
sleep 1
echo
read -n 1 -p "Do you want to revoke the Alert Policies listed above (y or n):" mainmenuinput
echo

if [ "$mainmenuinput" = "y" ]; then
  for alert_policy in $alert_policies_cleanup_list; do
    echo
    echo "=== DECOMMISSIONING $alert_policy ==="
    curl -X 'DELETE' -s\
      -H "Authorization: APIToken $VOLTERRA_TOKEN"\
      "$api_url/config/namespaces/shared/alert_policys/$alert_policy"; 
    sleep 1
    done
fi
