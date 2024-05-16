#!/bin/bash

API_TOKEN="$1"
ZONE_ID="$2"
CSR_CONTENT=$(cat "$3")
PRIVATE_KEY_CONTENT=$(cat "$4")

# Проверяем наличие сертификатов
EXISTING_CERTS=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/custom_certificates" \
     -H "Authorization: Bearer ${API_TOKEN}" \
     -H "Content-Type: application/json")

if echo "$EXISTING_CERTS" | jq -e '.result | length > 0' > /dev/null; then
    echo "Certificate already exists. Skipping creation."
    CERT_ID=$(echo "$EXISTING_CERTS" | jq -r '.result[0].id')
else
    RESPONSE=$(curl -s -X POST "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/custom_certificates" \
         -H "Authorization: Bearer ${API_TOKEN}" \
         -H "Content-Type: application/json" \
         --data '{
           "type": "origin-rsa",
           "csr": "'"${CSR_CONTENT}"'",
           "private_key": "'"${PRIVATE_KEY_CONTENT}"'"
         }')
    CERT_ID=$(echo $RESPONSE | jq -r '.result.id')
    echo "Created new certificate with ID: $CERT_ID"
fi

echo "CERT_ID=$CERT_ID" > certificate.env
