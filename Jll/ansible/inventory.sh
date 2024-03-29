#!/bin/bash
#login to portal


apt-get install jq -y

function print_azure_parameters {
cat<<EOF

Usage: $0  -u username -p password  -i tenantid -s subscription -r resourcegroup

      -u pass the username/clientid
          -p pass the clientsecret/password
          -i pass the tenantid
          -s pass the subscription
          -r pass the rg

Examples:

    running the ansible file with parameters
    ./login.sh -u asdfsd -p asdfas -i asdfg -s asdfasdsdfasdfsddd -r rgname"
EOF

exit 1
}

while getopts "u:p:i:s:r:e:" opt; do
        case "$opt" in
                u)
                        clientid=$OPTARG
                        ;;
                p)
                        password=$OPTARG
                        ;;
                i)
                        tenantid=$OPTARG
                        ;;
                s)
                        subscription=$OPTARG
                        ;;
                r)
                        resourcegroup=$OPTARG
                        ;;
                e)
                        env=$OPTARG
                        ;;
                *)
                        print_azure_parameters
                        ;;
        esac
done

[[ "$clientid" && "$password" && "$tenantid" && "$subscription" && "$resourcegroup" ]] || print_azure_parameters

az account set --subscription ${subscription} 1> /dev/null

az login --service-principal --username $clientid --password $password --tenant $tenantid 1> /dev/null



#To get ip address
tabip=( $(az vmss nic list -g $resourcegroup --vmss-name jll-am-tablea-rh-cluster --query [].{ip:ipConfigurations[0].privateIpAddress} -o tsv) )
nifiip=( $(az vmss nic list -g $resourcegroup --vmss-name jll-am-nifi-rh-instance --query [].{ip:ipConfigurations[0].privateIpAddress} -o tsv) )
j=0
echo [tableaumaster] > inventory

for i in "${tabip[@]}";
do
        echo $i
        echo $j
        j=$(( $j + 1 ))
        if [[ $j = 2 ]]; then
                echo -e "\n[tableauslave]" >> inventory
                echo $i >> inventory;
		echo $i >> hosts;
        else
                echo $i >> inventory;
		echo $i >> hosts;
        fi
done
j=0

echo -e "\n[nifi]" >> inventory

for i in "${nifiip[@]}";
do
     echo $i
done >> inventory

for i in "${nifiip[@]}";
do
     echo $i
done >> hosts



unset password
echo $password
