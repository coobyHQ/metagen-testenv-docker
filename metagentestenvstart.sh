#!/bin/bash

# Start & Stop WSO2 Identity Server to bootstrap it
sh /metagen-testenvironment/is/identity-server/bin/wso2server.sh > /dev/null &
#until $(curl --output /dev/null --silent --head --fail http://localhost:9443); do
#    printf '...'
#    sleep 3
#done
sleep 2m
sh /metagen-testenvironment/is/identity-server/bin/wso2server.sh stop > /dev/null &

# Move files


# Run backoffice
cd /metagen-testenvironment/bo/backoffice
npm run start-prod &
