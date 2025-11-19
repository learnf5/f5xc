#!/bin/bash

### variables
v_token="M6KjxIsIhxqzyNxKI6wUe36Kt+U="
v_url="training1.console.ves.volterra.io/api"
v_studentname="student107"
v_key="student107-key"
v_key_value="student107-key-value"
v_vsite="student107-vsite"
v_azure_site="student107-vnet"

### Test API token
### curl -s -H "Authorization: APIToken $v_token" -X GET "https://$v_url/web/namespaces/system/tenant/settings"

### curl -s -H "Authorization: APIToken $v_token" -X POST "https://$v_url/web/namespaces" -d '{"metadata":{"name":"'$v_studentname'"},"spec":{}}'

### curl -s -H "Authorization: APIToken $v_token" -X POST "https://$v_url/config/namespaces/shared/known_label_key/create" -d '{"key":"'$v_key'","namespace":"'$v_studentname'"}'

### sleep 1

### curl -s -H "Authorization: APIToken $v_token" -X POST "https://$v_url/config/namespaces/shared/known_label/create" -d '{"key":"'$v_key'","namespace":"'$v_studentname'","value":"'$v_key_value'"}'

### curl -s -H "Authorization: APIToken $v_token" -X POST "https://$v_url/config/namespaces/shared/virtual_sites" -d '{"metadata":{"name":"'$v_vsite'"},"spec":{"site_selector":{"expressions":["'$v_key' in ('$v_key_value')"]},"site_type":"CUSTOMER_EDGE"}}'

### curl -s -H "Authorization: APIToken $v_token" -X POST "https://$v_url/config/namespaces/system/azure_vnet_sites" -d '{"metadata":{"name":"'$v_azure_site'","labels":{"'$v_key'":"'$v_key_value'"}},"spec":{"resource_group":"student107-rg","azure_region":"eastus","vnet":{"new_vnet":{"name":"student107-vnet","primary_ipv4":"172.31.0.0/16"}},"ingress_gw":{"az_nodes":[{"azure_az":"1","local_subnet":{"subnet_param":{"ipv4":"172.31.107.0/24","ipv6":""}},"disk_size":0}],"azure_certified_hw":"azure-byol-voltmesh","performance_enhancement_mode":{"perf_mode_l7_enhanced":{}},"accelerated_networking":{"enable":{}}},"azure_cred":{"tenant":"training1-rcfjmagj","namespace":"system","name":"creds-azr1211gst01"},"machine_type":"Standard_D3_v2","disk_size":80,"volterra_software_version":"","operating_system_version":"","ssh_key": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDc+HSquvm6Bbvnk4h2KMR51MwnzBPWzbmhK5tiW8sC4rh+VzrcjNgnrc4Op7tFtLkv2sq/Vecg9QB6jMamGoBrqWP3qjejSxYWwr8xP/ZNRlqJNwGxEAQlDkUkKtUfNWgmOZtoVq249vvewyUCbmOlpgFDPPeNGfQrutJkOHmUj53kEIhhkoE+ZieY2Ls5fHTNgUDznf8KysnrIAr+reEKt7FREL+4kKnCp9ZlZtw/nw5sSDFNU9PRZuTwZIE85oY9nDxe9fRRttBSMHq9g0GD0iZg9fjafuB0Ft7qzkSq20vGrtYxfGgPW8kIjZBA95CSyA2gRsnSxUF7Fq+W50EWZfqU4O9KOZwKo8dTcbjmS+S5S5avK37uVn1v99rdG3Z9xbfBW8tohARDGlzC1R1Qh+LrfPgjds7oKXewT6hiHDe0wsMp25IxYUGEHqdEaAs4Bfos4Qw2Lwhjc2brNAO1aD9VpQPf9RMkv+gEDLoWdLEHw+qpRInDcO1N3kt8bQM= student@PC01","admin_password":null,"address":"","logs_streaming_disabled":{},"tags":{},"vip_params_per_az":[],"no_worker_nodes":{},"default_blocked_services":{},"offline_survivability_mode":{"no_offline_survivability_mode":{}},"user_modification_timestamp":null,"suggested_action":"","error_description":"","site_errors":[{"error_description":"","suggested_action":""}],"kubernetes_upgrade_drain":{"enable_upgrade_drain":{"drain_node_timeout":300,"drain_max_unavailable_node_count":1,"disable_vega_upgrade_mode":{}}},"cloud_site_info":{"public_ips":[],"private_ips":[],"spoke_vnet_prefix_info":[],"express_route_info":null,"node_info":[],"vnet":{"vnet_name":"student107-vnet","resource_id":""}}}}'

curl -s -H "Authorization: APIToken $v_token" -X POST "https://$v_url/terraform/namespaces/system/terraform/azure_vnet_site/$v_azure_site/run" -d '{"action":"APPLY"}'
