#!/bin/bash
whoami
yum update -y
yum install expect -y
yum install tableau-server-2019-2-0.x86_64.rpm -y
cp bootstrap.json /opt/tableau/tableau_server/packages/scripts.20192.19.0518.0639/
cd /opt/tableau/tableau_server/packages/scripts.20192.19.0518.0639/


/usr/bin/expect <<EOF

spawn ./initialize-tsm -b bootstrap.json -u provisioner -f --accepteula
expect {
"*(provisioner):" {send "$1\r";exp_continue }
sleep 5
}
EOF

systemctl stop firewalld
systemctl disable firewalld
systemctl mask --now firewalld

wget https://downloads.tableau.com/drivers/linux/yum/tableau-driver/tableau-postgresql-odbc-09.06.0500-1.x86_64.rpm

yum install tableau-postgresql-odbc-09.06.0500-1.x86_64.rpm -y

wget https://sfc-repo.snowflakecomputing.com/odbc/linux/2.19.15/snowflake-odbc-2.19.15.x86_64.rpm

yum install snowflake-odbc-2.19.15.x86_64.rpm -y
wget https://downloads.tableau.com/drivers/linux/yum/tableau-driver/tableau-freetds-1.00.40-1.x86_64.rpm
yum install tableau-freetds-1.00.40-1.x86_64.rpm -y

echo "slave setup completed"
