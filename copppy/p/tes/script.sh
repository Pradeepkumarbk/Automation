  wget http://packages.treasuredata.com.s3.amazonaws.com/2.5/redhat/7/x86_64/td-agent-2.5.0-0.el7.x86_64.rpm
    yum clean all
  yum install td-agent-2.5.0-0.el7.x86_64.rpm
  systemctl status td-agent.service
  /usr/sbin/td-agent-gem install fluent-plugin-secure-forward
 /usr/sbin/td-agent-gem install fluent-plugin-elasticsearch
 systemctl restart td-agent.service
 cat /etc/td-agent/td-agent.conf
 rm -rf /var/log/td-agent/td-agent.log
 tail /var/log/td-agent/td-agent.log
 vi /etc/init.d/td-agent
 service td-agent restart
 filestore.log
 chm
 Z766tioxYSI5 Z766tioxYSI5 
tsm maintenance cleanup -l --log-files-retention 7

#!/usr/bin/env bash
>/var/log/td-agent/td-agent.log
*/30 * * * * /home/provisioner/tdagent-log/tdagent.sh

 /home/provisioner/tdagent-log/tdagent.sh

curl -L http://toolbelt.treasuredata.com/sh/install-redhat-td-agent2.sh | sh

 yum install gcc gcc-c++ ruby-devel 
 curator --config /opt/elasticsearch-curator/config.yml /opt/elasticsearch-curator/action.yml
 flush_thread_count 8
      flush_interval 1s
      retry_forever true
      retry_max_interval 30
      chunk_limit_size 32M
      queue_limit_length 4

curl -u elastic:QwHlJwvd97Prk8dW9g4m "https://efk-1:9200/_cat/indices?v" --insecure
QwHlJwvd97Prk8dW9g4m
 ey)G%7w=
 UaPSdnkz0NMk
xTofKSr6VyyU
ClUu9NkFlJKK
xBg5qja@3Pub
Nls03gbtnYHS
vVeZgd1xkJ7i
usermod -a -G tableau td-agent
usermod -a -G root td-agent

 <source>
  @type tail
  path /var/opt/tableau/tableau_server/data/tabsvc/logs/searchserver/searchserver-0.log
  path /var/opt/tableau/tableau_server/data/tabsvc/logs/tabadmincontroller/tabadmincontroller_node1-0.log
  path /var/opt/tableau/tableau_server/data/tabsvc/logs/filestore/filestore.log/vizqlserver_node1-0.log
  path /var/opt/tableau/tableau_server/data/tabsvc/logs/vizqlserver
  time_format %Y-%m-%dT%H:%M:%S.%NZ
  tag hostname.system
  <parse>
    @type none
  </parse>
</source>
<match **>
  @type copy
  deep_copy true
  <store>
    @type stdout
  </store>
  <store>
    @type elasticsearch
    host 40.122.54.153
    port 9200
    logstash_format true
    logstash_prefix Nifi-prod
  </store>
</match>



#!/usr/bin/env bash

export AZURE_STORAGE_ACCOUNT=jllambackupdevpp
export AZURE_STORAGE_KEY=zxqvJtU1Q2OYX+38ghlEufYquk/r4dUOJMnbAugPaoH4bksabgM3h0wak6XYUvlNqibdEm/t1GIh42vbjj8Rew==

cd /var/opt/tableau/tableau_server/data/tabsvc/files/log-archives/
DATE=`date +%d-%m-%y`
tsm maintenance ziplogs -a -f log_$DATE
file=$(ls -SF  *.zip | sort -V | tail -1)
az storage blob upload -c tableau-preprod  --account-name jllambackupdevpp -f $file -n $file



#!/bin/sh
tsm maintenance clenaup -l log-files-retention 7
echo "Script Executed"
0 0 * * SAT /home/provisioner/diskclean/diskclean.sh


#!/bin/sh
cd /opt/nifiserver/nifi-1.9.2/logs
find . -iname '*.log' -mtime +10 -print0 | xargs -0 -r rm
echo "Script Executed"

0 */11 * * * /home/provisioner/diskclean/diskclean.sh



xTofKSr6VyyU 




#!/usr/bin/env bash
export AZURE_STORAGE_ACCOUNT=jllambackupdevpp
export AZURE_STORAGE_KEY=zxqvJtU1Q2OYX+38ghlEufYquk/r4dUOJMnbAugPaoH4bksabgM3h0wak6XYUvlNqibdEm/t1GIh42vbjj8Rew==
cd /var/opt/tableau/tableau_server/data/tabsvc/files/backups
timestamp=`date +"%T"`
echo $timestamp
source /etc/profile.d/tableau_server.sh
tsm maintenance backup -f ts_backup_$timestamp -d
file=$(ls -SF  *.tsbak | sort -V | tail -1)
az storage blob upload -c tableau  --account-name jllambackupdevpp -f $file -n $file
sleep 10
rm -rf $file


#!/usr/bin/env bash
export AZURE_STORAGE_ACCOUNT=jllambackupprod
export AZURE_STORAGE_KEY=fpHE72YjD36Q8FVdjoBMCB9ft0DFXDrxzzjh9e6YogFFXxroCcWR6RST51tyhgVa62IMgtK+DDyECull0K9KoA==
cd /var/opt/tableau/tableau_server/data/tabsvc/files/backups
timestamp=`date +"%T"`
echo $timestamp
source /etc/profile.d/tableau_server.sh
tsm maintenance backup -f ts_backup_$timestamp -d
file=$(ls -SF  *.tsbak | sort -V | tail -1)
az storage blob upload -c tableau  --account-name jllambackupprod -f $file -n $file
sleep 10
rm -rf $file


#!/usr/bin/env bash
cd /opt/
export AZURE_STORAGE_ACCOUNT=jllambackupprod
export AZURE_STORAGE_KEY=fpHE72YjD36Q8FVdjoBMCB9ft0DFXDrxzzjh9e6YogFFXxroCcWR6RST51tyhgVa62IMgtK+DDyECull0K9KoA==
DATE=`date +%d-%m-%y`
tar -cvzf nifiserver-$DATE.tar.gz nifiserver
tar -cvzf nifiregistry-$DATE.tar.gz nifi-registry-0.6.0
az storage blob upload -c nifi --account-name jllambackupdevpp -f nifiserver-$DATE.tar.gz -n nifiserver-$DATE.tar.gz
az storage blob upload -c nifi --account-name jllambackupdevpp -f nifiregistry-$DATE.tar.gz -n nifiregistry-$DATE.tar.gz
rm -rf nifiregistry-$DATE.tar.gz
rm -rf nifiserver-$DATE.tar.gz