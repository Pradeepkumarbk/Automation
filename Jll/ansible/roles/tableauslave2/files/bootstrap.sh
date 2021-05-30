#!/bin/bash

rpm --import https://packages.microsoft.com/keys/microsoft.asc
sh -c 'echo -e "[azure-cli]\nname=Azure CLI\nbaseurl=https://packages.microsoft.com/yumrepos/azure-cli\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/azure-cli.repo'
yum install azure-cli -y

export AZURE_STORAGE_ACCOUNT=$1
export AZURE_STORAGE_KEY=$2
az storage blob download --container-name tableau --file bootstrap.json  --name bootstrap.json
