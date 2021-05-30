#!/bin/bash
RESDIR=/opt/nifi
NIFISERVER=/opt/nifiserver

#Global variables
NIFI_VERSION=1.9.2
NIFI_FILE=nifi-$NIFI_VERSION-bin.tar.gz
NIFI_TOOLKIT_FILE=nifi-toolkit-$NIFI_VERSION-bin.tar.gz
NIFI_TOOLKIT_URL=https://archive.apache.org/dist/nifi/$NIFI_VERSION/$NIFI_TOOLKIT_FILE
NIFI_URL=https://archive.apache.org/dist/nifi/$NIFI_VERSION/$NIFI_FILE
NIFI_GIT_FLOW_PERSISTENCE_DIR=dp-red2-nifi-flows

usage() {
  echo "Usage : nifi.sh -f <fqdn>
                -u <adminuser>
                -c <OpenID-Connect-CLIENT_ID>
                -s <OpenID-Connect-CLIENT_SECRET>
                -d <OpenID-Connect-DISCOVERY_URL>
                -k <KEYSTORE FILE>
                -t <TRUSTORE FILE>
                -K <KEYSTORE PASSWORD>
                -T <TRUSTORE PASSWORD>
                -p <KEY PASSWORD>"
  echo "Example: ./nifi.sh -f red-data-stage.jll.com -u nifi_ops -c 0oa1453v5h12BygtQ357 -s Nmh3hGSw2UusKGuya9VDZOsI6GulftgCS7l1FK6f
          -d https://dev-812029-admin.okta.com/.well-known/openid-configuration -k /tmp/keystore.jks -t /tmp/trustore.jks -K keystorepassword -T truststorepassword
          -p keypassword"
}

while getopts 'f:u:c:s:d:k:t:K:T:p:' c
do
  case $c in
    f) FQDN=$OPTARG ;;
    u) ADMIN=$OPTARG ;;
    c) CLIENT_ID=$OPTARG ;;
    s) CLIENT_SECRET=$OPTARG ;;
    d) DISCOVERY_URL=$OPTARG ;;
    k) KEYSTORE=$OPTARG ;;
    t) TRUSTORE=$OPTARG ;;
    K) KEYSTORE_PASSWORD=$OPTARG ;;
    T) TRUSTORE_PASSWORD=$OPTARG ;;
    p) KEY_PASSWORD=$OPTARG ;;
    ?) usage; exit 1 ;;
  esac
done

if [ ! "$FQDN" ] || [ ! "$ADMIN" ] || [ ! "$CLIENT_ID" ] || [ ! "$CLIENT_SECRET" ] \
    || [ ! "$DISCOVERY_URL" ] || [ ! "$KEYSTORE" ] || [ ! "$TRUSTORE" ] \
    || [ ! "$KEYSTORE_PASSWORD" ] || [ ! "$TRUSTORE_PASSWORD" ] \
    || [ ! "$KEY_PASSWORD" ]
then
    usage
    exit 1
fi

echo $*

# Update packagse
echo "Updating system"
sudo yum -y update
sudo yum -y install wget

#to do: Is it required : It should not be 0.0.0.0
sudo echo "0.0.0.0 ${FQDN}" >>/etc/hosts

# Install Java
echo "Installing Java"
#echo 2 | sudo alternatives --config java
#sudo yum install -y java-1.8.0-openjdk-devel-1.8.0.222.b10-0.el7_6
#echo "export Java"
#export JAVA_HOME=/usr/java/jdk1.8.0_161/jre
#export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.222.b10-0.el7_6.x86_64/jre
#sudo sh -c "echo JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.222.b10-0.el7_6.x86_64/jre >> /etc/environment"
sudo yum install java-1.8.0-openjdk -y
sudo echo $JAVA_HOME
echo "export PATH"
export PATH=$PATH:$JAVA_HOME/bin
sudo echo $PATH
#source /etc/profile

# Increase the limits of File Handles
# NiFi will at any one time potentially have a very large number of file handles open.
echo "*  hard  nofile  50000" >> /etc/security/limits.conf
echo "*  soft  nofile  50000" >> /etc/security/limits.conf

# Increase the allowable number of Forked Processes
# NiFi may be configured to generate a significant number of threads.
echo "*  hard  nproc  10000" >> /etc/security/limits.conf
echo "*  soft  nproc  10000" >> /etc/security/limits.conf
echo "*  soft  nproc  10000" >> /etc/security/limits.d/90-nproc.conf

# Increase the number of TCP socket ports available
sysctl -w net.ipv4.ip_local_port_range="10000 65000"

# Set how long sockets stay in a TIMED_WAIT state when closed
echo 'net.ipv4.netfilter.ip_conntrack_tcp_timeout_time_wait="1"' >> /etc/sysctl.conf

# Swapping is fantastic for some applications. It isn’t good for something like NiFi that always wants to be running.
echo "vm.swappiness = 0" >> /etc/sysctl.conf
sysctl -w vm.swappiness=0

#Firewall : Review the ports
sudo firewall-cmd --zone=public --add-service=https
sudo firewall-cmd --zone=public --permanent --add-service=https
sudo firewall-cmd --zone=public --permanent --add-port=8080/tcp
sudo firewall-cmd --zone=public --permanent --add-port=18080/tcp
sudo firewall-cmd --zone=public --permanent --add-port=5000/tcp
sudo firewall-cmd --zone=public --permanent --add-port=4990-4999/udp
sudo firewall-cmd --zone=public --permanent --add-port=50000/tcp
sudo firewall-cmd --zone=public --permanent --add-port=9443/tcp
sudo firewall-cmd --zone=public --add-port=22/tcp
sudo firewall-cmd --zone=public --add-port=8080/tcp
sudo firewall-cmd --zone=public --add-port=9443/tcp
sudo firewall-cmd --zone=public --add-port=18080/tcp

# download nifi if not present
if [ ! -f $RESDIR/$NIFI_FILE ]
then
        echo "Downloading NIFI"
        sudo wget $RESDIR/$NIFI_FILE $NIFI_URL
fi

########################
########################
# install in a linuxy way
echo "Installing NIFI from $RESDIR/$NIFI_FILE"
sudo tar -xzf $RESDIR/$NIFI_FILE

########################
########################
#Symbolic link
echo "move to share and symbolic link"
sudo cp -r $RESDIR/nifi-$NIFI_VERSION $NIFISERVER/

#Add permission
sudo chmod -R 755  $NIFISERVER/nifi-$NIFI_VERSION
sudo ln -s $NIFISERVER/nifi-$NIFI_VERSION/bin/nifi.sh /usr/bin/nifi
#sudo rm -rf nifi-$NIFI_VERSION
echo "Done installing NIFI"
########################

#Copy the keystore and trusttore to conf directory
sudo cp $KEYSTORE $NIFISERVER/nifi-$NIFI_VERSION/conf/keystore.jks
if [ $? -ne 0 ]
then
  echo "Error: Copying keystore file"
  exit 1
fi

sudo cp $TRUSTORE $NIFISERVER/nifi-$NIFI_VERSION/conf/trustore.jks
if [ $? -ne 0 ]
then
  echo "Error: Copying trustore file"
  exit 1
fi

#####################################################################
# Setup security for Nifi
####################################################################
echo "Modifying nifi.properties"
cd $NIFISERVER/nifi-$NIFI_VERSION/conf/
if [ ! -f nifi_properties_original ]
then
  echo "Create a back up of original file"
  sudo cp nifi.properties nifi_properties_original
fi

URL_ESCAPED=$(echo ${DISCOVERY_URL} |sed -e 's/\//\\\//g')
sudo cat <<EOF >sed_script
s/nifi.security.user.oidc.discovery.url=/nifi.security.user.oidc.discovery.url=${URL_ESCAPED}/
s/nifi.security.user.oidc.client.id=/nifi.security.user.oidc.client.id=${CLIENT_ID}/
s/nifi.security.user.oidc.client.secret=/nifi.security.user.oidc.client.secret=${CLIENT_SECRET}/
s/nifi.security.keystore=/nifi.security.keystore=.\/conf\/keystore.jks/
s/nifi.security.keystoreType=/nifi.security.keystoreType=jks/
s/nifi.security.keystorePasswd=/nifi.security.keystorePasswd=${KEYSTORE_PASSWORD}/
s/nifi.security.keyPasswd=/nifi.security.keyPasswd=${KEY_PASSWORD}/
s/nifi.security.truststore=/nifi.security.truststore=.\/conf\/trustore.jks/
s/nifi.security.truststoreType=/nifi.security.truststoreType=jks/
s/nifi.security.truststorePasswd=/nifi.security.truststorePasswd=${TRUSTORE_PASSWORD}/
s/nifi.web.https.host=/nifi.web.https.host=${FQDN}/
s/nifi.web.https.port=/nifi.web.https.port=9443/
s/nifi.web.http.port=8080/nifi.web.http.port=/
s/nifi.remote.input.http.enabled=true/nifi.remote.input.http.enabled=false/
/^#.*nifi\.security\.identity\.mapping\.pattern\.dn.*/s/^#//
/^#.*nifi\.security\.identity\.mapping\.value\.dn.*/s/^#//
/^#.*nifi\.security\.identity\.mapping\.transform\.dn.*/s/^#//
/^#.*nifi\.security\.identity\.mapping\.pattern\.kerb.*/s/^#//
/^#.*nifi\.security\.identity\.mapping\.value\.kerb.*/s/^#//
/^#.*nifi\.security\.identity\.mapping\.transform\.kerb.*/s/^#//
EOF

echo "Modifying nifi.properties file"
sudo sed -i -f sed_script nifi.properties

#Save original file
if [ ! -f authorizers_original.xml ]
then
  echo "Create a back up of original file"
  sudo cp authorizers.xml authorizers_original.xml
fi

sudo cat <<EOF >sed_script1
s/<property name="Initial Admin Identity"><\/property>/<property name="Initial Admin Identity">${ADMIN}<\/property>/g
s/<property name="Initial User Identity 1"><\/property>/<property name="Initial User Identity 1">${ADMIN}<\/property>/g
EOF

echo "Modifying Authorizers file"
sudo sed -i -f sed_script1 authorizers.xml


#######################
echo "Starting NIFI"
sudo nifi install
sudo systemctl daemon-reload
sudo service nifi start
########################

########################
echo "NIFI listening on port 9443. It may take several minutes for the UI to come up. Keep trying if you get 404's."
########################


##########################
echo "Downloading Nifi toolkit"

# download nifi registry if not present
if [ ! -f $RESDIR/$NIFI_TOOLKIT_FILE ]
then
    echo "Downloading NIFI TOOLKIT BUNDLE"
    sudo wget https://archive.apache.org/dist/nifi/1.9.2/nifi-toolkit-1.9.2-bin.tar.gz
    if [ $? -ne 0 ]
    then
         echo "Error: Download nifi toolkit. Please review the error and try again"
         exit 1
    fi

fi

echo "Installing Nifi Registry from $RESDIR/$NIFI_TOOLKIT_FILE"
sudo tar -xzf $RESDIR/$NIFI_TOOLKIT_FILE

echo "Move the nifi toolkit to $NIFISERVER"
sudo cp -r $RESDIR/nifi-toolkit-$NIFI_VERSION $NIFISERVER/
echo "Done install Nifi toolkit"

########################
#nifi-registry install and start
echo "Installing Nifi-Registry"
cd $RESDIR
wget https://www-us.apache.org/dist/nifi/nifi-registry/nifi-registry-0.4.0/nifi-registry-0.4.0-bin.tar.gz
NIFIREGISTRY=nifi-registry-0.4.0
sudo tar -xzf $RESDIR/$NIFIREGISTRY-bin.tar.gz
sudo cp -r $RESDIR/$NIFIREGISTRY /opt/

#To do : Add git flow persistence to Nifi registry
sudo bash /opt/nifi-registry-0.4.0/bin/nifi-registry.sh install
sleep 25
sudo systemctl daemon-reload
sudo service nifi-registry start
#sudo bash /opt/nifi-registry-0.4.0/bin/nifi-registry.sh start
echo "NIFI-registry listening on port 18080. It may take several minutes for the UI to come up. Keep trying if you get 404's."

#nifi-registry install done and started

cd $NIFISERVER/nifi-1.9.2/conf/

sed -i 's/-Xms512m/-Xms4096m/g' bootstrap.conf
sed -i 's/-Xmx512m/-Xmx4096m/g' bootstrap.conf
########################
########################
