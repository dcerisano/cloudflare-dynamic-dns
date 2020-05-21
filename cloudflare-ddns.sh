#/usr/bin/env sh

source ./config


A_RECORD_ID=($(curl -X GET "https://api.cloudflare.com/client/v4/zones/$CLOUDFLARE_ZONE_ID/dns_records?type=A&name=$CLOUDFLARE_RECORD_NAME" \
     -H "Host: api.cloudflare.com" \
     -H "User-Agent: ddclient/3.9.0" \
     -H "Connection: close" \
     -H "X-Auth-Email: ${CLOUDFLARE_EMAIL}" \
     -H "X-Auth-Key: ${CLOUDFLARE_KEY}" \
     -H "Content-Type: application/json" -s | jq -r ".result[].id"))



# Retrieve the last recorded public IP address
IP_RECORD="/tmp/ip-record"
RECORDED_IP=`cat $IP_RECORD`

# Fetch the current public IP address
PUBLIC_IP=$(curl --silent https://api.ipify.org) || exit 1

#If the public ip has not changed, nothing needs to be done, exit.
if [ "$PUBLIC_IP" = "$RECORDED_IP" ]; then
   echo "IP already set to $RECORDED_IP, exiting"
   exit 0
fi

# Otherwise, your Internet provider changed your public IP again.
# Record the new public IP address locally
echo $PUBLIC_IP > $IP_RECORD

# Record the new public IP address on Cloudflare using API v4
RECORD=$(cat <<EOF
{ "type": "A",
  "name": "$CLOUDFLARE_RECORD_NAME",
  "content": "$PUBLIC_IP",
  "ttl": 180,
  "proxied": false }
EOF
)
curl "https://api.cloudflare.com/client/v4/zones/$CLOUDFLARE_ZONE_ID/dns_records/$A_RECORD_ID" \
     -X PUT \
     -H "Content-Type: application/json" \
     -H "X-Auth-Email: ${CLOUDFLARE_EMAIL}" \
     -H "X-Auth-Key: ${CLOUDFLARE_KEY}" \
     -d "$RECORD"
