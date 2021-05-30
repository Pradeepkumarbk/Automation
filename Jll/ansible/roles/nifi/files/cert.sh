#!/bin/bash

rpm --import https://packages.microsoft.com/keys/microsoft.asc
sh -c 'echo -e "[azure-cli]\nname=Azure CLI\nbaseurl=https://packages.microsoft.com/yumrepos/azure-cli\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/azure-cli.repo'
yum install azure-cli -y


export AZURE_STORAGE_ACCOUNT=$1
export AZURE_STORAGE_KEY=$2
cd /home/provisioner/
az storage blob download --container-name kafka --file truststore.jks  --name kafka.client.truststore.jks
#az storage blob download --container-name kafka --file keystore.jks  --name keystore.jks

wget https://repo1.maven.org/maven2/com/microsoft/sqlserver/mssql-jdbc/7.0.0.jre8/mssql-jdbc-7.0.0.jre8.jar

chmod 755 *

cd /opt/nifi/
az storage blob download --container-name nifi --file truststore.jks  --name truststore.jks
az storage blob download --container-name nifi --file keystore.jks  --name keystore.jks




