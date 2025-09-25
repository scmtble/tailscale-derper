#!/bin/sh

if [ ! -f "${DERPER_CERTS}/${DERPER_IP}.key" ] || [ ! -f "${DERPER_CERTS}/${DERPER_IP}.crt" ]; then
    echo "Generating self-signed certificate for ${DERPER_IP}..."
    mkdir -p "${DERPER_CERTS}"
    openssl req -new -newkey rsa:4096 -x509 -sha256 -days 3650 -nodes \
        -keyout "${DERPER_CERTS}/${DERPER_IP}.key" \
        -out "${DERPER_CERTS}/${DERPER_IP}.crt" \
        -subj "/CN=${DERPER_IP}" \
        -addext "subjectAltName=IP:${DERPER_IP}" 2> /dev/null

    echo "Self-signed certificate generated at ${DERPER_CERTS}/${DERPER_IP}.crt and ${DERPER_CERTS}/${DERPER_IP}.key"
else
    echo "Certificate for ${DERPER_IP} already exists. Skipping generation."
fi

/derper --hostname=${DERPER_IP} -certmode manual -certdir ${DERPER_CERTS}