#!/bin/bash
#login to portal


apt-get install jq -y

function print_azure_parameters {
cat<<EOF

Usage: $0  -u username -p password  -i tenantid -s subscription -r resourcegroup -t tabresourcegroup -v aksresourcegroup

      -u pass the username/clientid
          -p pass the clientsecret/password
          -i pass the tenantid
          -s pass the subscription
          -r pass the rg
          -t pass the tableau resourse group name
          -v pass the aks resourse group name

Examples:

    running the ansible file with parameters
    ./login.sh -u asdfsd -p asdfas -i asdfg -s asdfasdsdfasdfsddd -r rgname"
EOF

exit 1
}

while getopts "u:p:i:s:r:t:v:e:" opt; do
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
                t)
                        tabresourcegroup=$OPTARG
                        ;;
                v)
                        aksresourcegroup=$OPTARG
                        ;;
                e)
                        env=$OPTARG
                        ;;
                *)
                        print_azure_parameters
                        ;;
        esac
done

[[ "$clientid" && "$password" && "$tenantid" && "$subscription" && "$resourcegroup" && "$tabresourcegroup" && "$aksresourcegroup" ]] || print_azure_parameters

az login --service-principal --username $clientid --password $password --tenant $tenantid 1> /dev/null

az account set --subscription ${subscription} 1> /dev/null

#To get ip address
vmip=( $(az vm list-ip-addresses -g $tabresourcegroup --query "[].{id:virtualMachine.network.publicIpAddresses[0].ipAddress}" --output tsv ) )
aksvmip=( $(az vm list-ip-addresses -g $aksresourcegroup --query "[].{id:virtualMachine.network.privateIpAddresses[0]}" --output tsv) )
nifiip=( $(az vmss nic list -g $resourcegroup --vmss-name nifdev --query [].{ip:ipConfigurations[0].privateIpAddress} -o tsv) )
j=0
for i in "${vmip[@]}";
do
        j=$(( $j + 1 ))
        if [[ $j = 1 ]]; then
                echo -e "\n[tableau]" >> inventory
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

echo -e "\n[vm]" >> inventory

for i in "${aksvmip[@]}";
do
        echo $i
done >> inventory

for i in "${aksvmip[@]}";
do
        echo $i 
done >> hosts


unset password
echo $password
