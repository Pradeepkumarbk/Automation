#################################################
# Script to automate user creation and policies
# Tasks
# 1. Register nifi with nifi registry
# 2. Create users and apply policies to them
# 3. Users are read from a file "users.txt"
# 4. Policies are hardcoded in the code.
##################################################

import os
import nipyapi
import yaml
import argparse
import logging
import ssl
import urllib.request
from configparser import ConfigParser

# Logging Configuration
logger = logging.getLogger('main')
logger.setLevel(logging.DEBUG)

USERS_FILE_NAME = "users.conf"
#ADMIN_USER = "CN=red-data-stage.jll.com, OU=RED2, O=&quot;Jones Lang LaSalle IP, Inc.&quot;, L=Chicago, ST=Illinois, C=US"

# Read command line
def init():
    logger.info("init:Initialize args")
    parser = argparse.ArgumentParser()
    parser.add_argument("--location", help="Location of the users.txt file", default="./")
    parser.add_argument("nifiUrl", help="Nifi URL for target environment. Example: http://localhost:8080/nifi-api")
    parser.add_argument("nifiRegistryUrl", help="Nifi Registry URL for target environment."
                                               " Example: http://localhost:18080/nifi-registry-api")
    #parser.add_argument("key", help="Location of the users.txt file", default="./")
    args = parser.parse_args()
    return args

# Read list of users form config file
def get_users_list(location):
    config_parser = ConfigParser()
    config_parser.read(location+"/"+USERS_FILE_NAME)
    return config_parser.get("nifi-users", "userid")

# Create users and bootstrap policies
def main():
    # Initialize input args
    logger.info("Reading Command line Args")
    args = init()

    logger.info("Input - %s", args)

    # Read the users from input file
    users=get_users_list(args.location)
    users_list = list(users.split(','))
    logger.info("Users - %s", users_list)

    nipyapi.utils.set_endpoint(args.nifiRegistryUrl)
    nipyapi.utils.set_endpoint(args.nifiUrl)
    #nipyapi.nifi.configuration.verify_ssl = True

    # Read the path to certificates from environment variables
    client_cert_file = os.environ['CLIENT_CERT_FILE']
    client_key_file = os.environ['CLIENT_KEY_FILE']
    ca_file = os.environ['CA_FILE']

    nipyapi.security.set_service_ssl_context(service='nifi',
                                             ca_file=ca_file,
                                             client_cert_file=client_cert_file,
                                             client_key_file=client_key_file,
                                             client_key_password=None)
    # Add registry client
    url = os.path.dirname(args.nifiRegistryUrl)
    try:
        nipyapi.versioning.create_registry_client("registry", url, "RegistryClient")
        logger.info("Added registry client")
    except Exception as e:
        logger.error("Failed to create registry client")
        logger.error(e)
        #exit(1)

    for user in users_list:
        logger.info("Adding policies for user : %s",user)
        try:
            user_entity=nipyapi.security.create_service_user(user, service='nifi', strict = False)
            nipyapi.security.bootstrap_security_policies("nifi", user_entity)
        except:
            logger.error("Failed to create user or bootstrap policies")
            logger.error(e)
            exit(1)

        #rpg_id = nipyapi.canvas.get_root_pg_id()
        access_policies = [
            ('read', '/flow', None),
            ('write', '/flow', None),
            ('read', '/controller',None),
            ('write', '/controller', None),
            ('read', '/provenance',None),
            ('write', '/provenance', None),
            ('read', '/restricted-components', None),
            ('write', '/restricted-components', None),
            ('read', '/policies', None),
            ('write', '/policies', None),
        ]

        for pol in access_policies:
            logger.info("Applying policies : %s",pol)
            try:
                ap = nipyapi.security.get_access_policy_for_resource(
                    action=pol[0],
                    resource=pol[1],
                    r_id=pol[2],
                    service='nifi',
                    auto_create=True
                )
                nipyapi.security.add_user_to_access_policy(
                    user=user_entity,
                    policy=ap,
                    service='nifi',
                    strict=False
                )
            except:
                logger.error("Failed to add user to policy")
                logger.error(e)
                exit(1)

main()
