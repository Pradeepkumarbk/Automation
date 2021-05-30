### Nifi Installation Script
1. Install Nifi and setup SSL & Authentication using Okta
2. Install Nifi registry - No SSL for Registry

### Running Nifi Installation script

```Usage: nifi.sh -f <fqdn> -u <adminuser> -c <OpenID-Connect-CLIENT_ID> -s <OpenID-Connect-CLIENT_SECRET> -d <OpenID-Connect-DISCOVERY_URL> -k <KEYSTORE FILE> -t <TRUSTORE FILE> -K <KEYSTORE PASSWORD> -T <TRUSTORE PASSWORD> -p <KEY PASSWORD>```
#### Example:        
```sudo sh -x nifi.sh -f red-data-stage.jll.com -u 'CN=red-data-stage.jll.com, OU=RED2, O=\"Jones Lang LaSalle IP, Inc.\";, L=Chicago, ST=Illinois, C=US' -c 0oa1453v5h12BygtQ357 -s Nmh3hGSw2UusKGuya9VDZOsI6GulftgCS7l1FK6f  -d https://dev-812029-admin.okta.com/.well-known/openid-configuration -k /home/provisioner/keystore.jks -t /home/provisioner/truststore.jks -K keystorepassword -T truststorepassword  -p keypassword```

#### Note: Please use ```CN=red-data-stage.jll.com, OU=RED2, O=\"Jones Lang LaSalle IP, Inc.\";, L=Chicago, ST=Illinois, C=US``` as the Initial Admin user for Nifi installation

### Nifi create user python script 
1. Create Registry client
2. Create Users listed in users.xml
3. Apply policies listed in the code [ Policies are hardcoded in the python code ]

#### Running Nifi python script 
1. ```#python3 create_user.py <nifiUrl> nifiRegistryUrl>```
2. ```#python3 create_user.py https://red-data-stage.jll.com:9443/nifi-api http://localhost:18080/nifi-registry-api```
