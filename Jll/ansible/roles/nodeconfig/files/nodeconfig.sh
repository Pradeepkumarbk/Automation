#!/bin/bash
whoami
sleep 90
source /etc/profile.d/tableau_server.sh
tsm topology set-process -n node2 -pr clustercontroller -c 1
sleep 3
tsm topology set-process -n node3 -pr clustercontroller -c 1
sleep 3
tsm pending-changes apply --ignore-warnings --ignore-prompt
sleep 3
tsm login -u provisioner -p $1

tsm stop

echo "Deploy a Coordination Service ensemble"

tsm topology deploy-coordination-service -n node1,node2,node3 && sleep 600

echo "Clean up coordination Service"

tsm topology cleanup-coordination-service && sleep 100
tsm start

echo "Configure processes for the second node======"

tsm topology set-process -n node2 -pr gateway -c 1
tsm topology set-process -n node2 -pr vizqlserver -c 2
tsm topology set-process -n node2 -pr vizportal -c 2
tsm topology set-process -n node2 -pr backgrounder -c 2
tsm topology set-process -n node2 -pr cacheserver -c 2
tsm topology set-process -n node2 -pr searchserver -c 1
tsm topology set-process -n node2 -pr dataserver -c 2
tsm topology set-process -n node2 -pr filestore -c 1

tsm pending-changes apply --ignore-warnings --ignore-prompt && sleep 60

echo "Configure processes for the third node"

tsm topology set-process -n node3 -pr gateway -c 1
tsm topology set-process -n node3 -pr searchserver -c 1
tsm topology set-process -n node3 -pr filestore -c 1
tsm topology set-process -n node2 -pr pgsql -c 1

tsm settings import -f lb.json


cd /var/opt/tableau/tableau_server/data/ssl

tsm security external-ssl enable --cert-file tableau.crt --key-file private.key

tsm pending-changes apply --ignore-warnings --ignore-prompt && sleep 60

tsm start && sleep 5
