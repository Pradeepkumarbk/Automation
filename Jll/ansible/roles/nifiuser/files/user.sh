#!/bin/bash
export AZURE_STORAGE_ACCOUNT=$1
export AZURE_STORAGE_KEY=$2
cd /opt/
az storage blob download --container-name nifi --file privatepreprod.key  --name privatepreprod.key
az storage blob download --container-name nifi --file DigiCertCA.crt   --name DigiCertCA.crt
az storage blob download --container-name nifi --file red-data-preprod_jll_com.crt  --name red-data-preprod_jll_com.crt 

pwd
export CLIENT_KEY_FILE=/opt/privatepreprod.key
export CA_FILE=/opt/DigiCertCA.crt
export CLIENT_CERT_FILE=/opt/red-data-preprod_jll_com.crt

cd /root/dp-red2-devops-ansible/ansible/roles/nifiuser/files

echo $3

python3 create_user.py https://$3:9443/nifi-api http://$3:18080/nifi-registry-api
