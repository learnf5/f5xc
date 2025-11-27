#!/bin/bash

### variables
v_token="M6KjxIsIhxqzyNxKI6wUe36Kt+U="
v_url="training1.console.ves.volterra.io/api"

### Test the token
### curl -s -H "Authorization: APIToken $v_token" -X GET "https://$v_url/web/namespaces/system/tenant/settings"
### sleep 2
### List the Zones
### curl -s -H "Authorization: APIToken $v_token" -X GET "https://$v_url/config/dns/namespaces/system/dns_zones"
### sleep 2
### Get the Zone
### curl -s -H "Authorization: APIToken $v_token" -X GET "https://$v_url/config/dns/namespaces/system/dns_zones/f5training1.cloud"
### sleep 2
### Add one record
curl -s -H "Authorization: APIToken $v_token" -X GET "https://$v_url/config/dns/namespaces/system/dns_zones/f5training1.cloud/rrsets/x-ves-io-managed"  -d '{"dns_zone_name":"f5training1.cloud","group_name":x-ves-io-managed","rrset":{"a_record":{"name:"record77","values":["10.10.10.150"]}}}'
