#!/bin/bash

API_TOKEN="$1"
ZONE_NAME="fourthestate.app"
CSR_PATH="$2"
CERT_DIR="./certs" 


mkdir -p "$CERT_DIR"

CERTIFICATES=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones?name=${ZONE_NAME}/ssl/certificates" \
     -H "Authorization: Bearer ${API_TOKEN}" \
     -H "Content-Type: application/json")

CERT_ID=$(echo "$CERTIFICATES" | jq -r '.result[] | select(.hosts == ["fourthestate.app", "*.fourthestate.app"]) | .id')

if [ -z "$CERT_ID" ]; then
    CSR_CONTENT=$(cat "$CSR_PATH")

  
    echo "$CSR_CONTENT" > "${CERT_DIR}/leaf.crt"

    echo "Certificate downloaded and saved."
else
    echo "Certificate already exists with ID: $CERT_ID"
fi


echo "CERT_DIR=${CERT_DIR}" > certificate.env
