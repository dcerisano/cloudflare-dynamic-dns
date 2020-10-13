#/usr/bin/env sh
#Script to fetch your CF "dynamic" A-record ID
#You need the Zone ID, Authorization key and A-record ID for your domain.
#Fetch the first two from your CF account.
#Create the A-record in CF named “dynamic”.
#Create the CNAME alias (example.com --> dynamic.example.com 1)
#Fetch The A-record ID:

source ./config.sh

curl -X GET "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records?type=A&name=dynamic" \
     -H "Host: api.cloudflare.com" \
     -H "User-Agent: ddclient/3.9.0" \
     -H "Connection: close" \
     -H "X-Auth-Email: $AUTH_EMAIL" \
     -H "X-Auth-Key: $AUTH_KEY" \
     -H "Content-Type: application/json"
