#!/bin/bash

API_TOKEN="$1"
ZONE_ID="$2"
CSR_CONTENT=$(cat "$3")
PRIVATE_KEY_CONTENT=$(cat "$4")

curl -X POST "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/custom_certificates" \
     -H "Authorization: Bearer ${API_TOKEN}" \
     -H "Content-Type: application/json" \
     --data '{
       "type": "origin-rsa",
       "csr": "'"${CSR_CONTENT}"'",
       "private_key": "'"${PRIVATE_KEY_CONTENT}"'"
     }'
