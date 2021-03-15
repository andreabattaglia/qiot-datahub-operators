#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Missing Projects"
fi

export PROJECT=$1
export PKI=${PROJECT}-pki
export DOMAIN=${PROJECT}.qiot-project.io
export ROLE=${PROJECT}-qiot-project-io
export SERVICE_ACCOUNT=issuer

echo "Setup on ${PROJECT}"

echo "Enable PKI Engine ${PKI}"

vault secrets enable -tls-skip-verify --path=${PKI} pki
# 1 Year
vault secrets tune -tls-skip-verify -max-lease-ttl=8760h ${PKI}

vault write -tls-skip-verify ${PKI}/root/generate/internal \
    common_name=${DOMAIN} \
    ttl=8760h

echo "CRL Configuration"

vault write -tls-skip-verify ${PKI}/config/urls \
    issuing_certificates="https://127.0.0.1:8200/v1/${PKI}/ca" \
    crl_distribution_points="https://127.0.0.1:8200/v1/${PKI}/crl"

echo "https://127.0.0.1:8200/v1/${PKI}/ca"
echo "https://127.0.0.1:8200/v1/${PKI}/crl"

echo "Configure Role for domain: ${DOMAIN}"

vault write -tls-skip-verify ${PKI}/roles/qiot-project-io \
    allowed_domains=${DOMAIN},${PROJECT}.svc \
    allow_subdomains=true \
    allowed_other_sans="*" \
    allow_glob_domains=true \
    max_ttl=365d

echo "Create PKI Policy pki-${ROLE}-policy"

vault policy write --tls-skip-verify pki-${ROLE}-policy - <<EOF
path "${PKI}*"                               { capabilities = ["read", "list"] }
path "${PKI}/roles/qiot-project-io"   { capabilities = ["create", "update"] }
path "${PKI}/sign/qiot-project-io"    { capabilities = ["create", "update"] }
path "${PKI}/issue/qiot-project-io"   { capabilities = ["create"] }
EOF

echo "Authorize ServiceAccount issuer on ${PROJECT}"

vault write --tls-skip-verify auth/kubernetes/role/${ROLE} \
  bound_service_account_names=${SERVICE_ACCOUNT} bound_service_account_namespaces="${PROJECT}" \
  policies=pki-${ROLE}-policy \
  ttl=2h
