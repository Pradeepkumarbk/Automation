#!/bin/bash


export AZURE_STORAGE_ACCOUNT=$1
export AZURE_STORAGE_KEY=$2
cd /var/opt/tableau/tableau_server/data/ssl/
#az storage blob download --container-name tableau --file private.key  --name private.key
az storage blob download-batch -d . --pattern *.key -s tableau
az storage blob download-batch -d . --pattern *.crt -s tableau
cp *reports* tableau.crt
cp *.key private.key
#az storage blob download --container-name tableau --file red-reports-stage_jll_com.crt  --name red-reports-stage_jll_com.crt
