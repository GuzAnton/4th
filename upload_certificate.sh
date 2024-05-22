#!/bin/bash

API_TOKEN="$1"
ZONE_NAME="$2"
CSR_PATH="$3"
CERT_DIR="${4:-./certs}"  


mkdir -p "$CERT_DIR"


create_tls_certificate() {
    CSR_CONTENT=$(cat "$CSR_PATH")

   
    RESPONSE=$(curl -s -X POST "https://api.cloudflare.com/client/v4/zones?name=${ZONE_NAME}/ssl/certificates" \
         -H "Authorization: Bearer ${API_TOKEN}" \
         -H "Content-Type: application/json" \
         --data '{
           "csr": "'"${CSR_CONTENT}"'"
         }')

    CERT_ID=$(echo "$RESPONSE" | jq -r '.result.id')
    echo "Created new TLS certificate with ID: $CERT_ID"

   
    echo "$CSR_CONTENT" > "${CERT_DIR}/certificate.pem"

    
    echo "{\"CERT_DIR\":\"${CERT_DIR}\"}"
}


if [ -f "${CERT_DIR}/certificate.pem" ]; then
    echo "{\"CERT_DIR\":\"${CERT_DIR}\"}"
else
   
    create_tls_certificate
fi
