#!/bin/bash

API_TOKEN="$1"
ZONE_NAME="fourthestate.app"
CSR_PATH="$2"
CERT_DIR="./certs"


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
}


if [ -f "${CERT_DIR}/certificate.pem" ]; then
    echo "TLS certificate already exists."
else

    create_tls_certificate
fi


echo "CERT_DIR=${CERT_DIR}" > certificate.env
