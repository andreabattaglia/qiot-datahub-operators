# Vault Installation

1. Configure Helm Repository

    ```
    helm repo add hashicorp https://helm.releases.hashicorp.com
    helm search repo hashicorp/vault
    ```

2. Install Vault

    ```
    helm install vault hashicorp/vault -f override-standalone.yaml
    ```
3. Init Vault and Unseal

    ```
    oc rsh vault-0
    vault operator init -tls-skip-verify -key-shares=1 -key-threshold=1

    Unseal Key 1: BwM/CVRTq0cgYvkZdyqV98uHkxWkTO+eGWO1jZAnTbw=

    Initial Root Token: s.a5qNdR8daXNuai6g8tboAV6O

    export KEYS=BwM/CVRTq0cgYvkZdyqV98uHkxWkTO+eGWO1jZAnTbw=
    export VAULT_TOKEN=s.a5qNdR8daXNuai6g8tboAV6O

    vault operator unseal -tls-skip-verify $KEYS

    ```
4. Enable PKI Engine

    ```
    vault secrets enable -tls-skip-verify --path=cert-manager-io pki
    # 1 Year
    vault secrets tune -tls-skip-verify -max-lease-ttl=8760h cert-manager-io

    vault write -tls-skip-verify cert-manager-io/root/generate/internal \
        common_name=qiot-project.github.io \
        ttl=8760h
    ```
5. CRL Configuration

    ```
    vault write -tls-skip-verify cert-manager-io/config/urls \
        issuing_certificates="https://127.0.0.1:8200/v1/cert-manager-io/ca" \
        crl_distribution_points="https://127.0.0.1:8200/v1/cert-manager-io/crl"
    ```

6. Configure a Role for domain qiot-project.github.io

    ```
    vault write -tls-skip-verify cert-manager-io/roles/qiot-project-github-io \
    allowed_domains=qiot-project.github.io,svc \
    allow_subdomains=true \
    allowed_other_sans="*" \
    allow_glob_domains=true \
    max_ttl=72h
    ```

6. Enable Kubernetes Auth

    ```
    JWT=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
    KUBERNETES_HOST=https://${KUBERNETES_PORT_443_TCP_ADDR}:443

    vault auth enable --tls-skip-verify kubernetes
    vault write --tls-skip-verify auth/kubernetes/config token_reviewer_jwt=$JWT kubernetes_host=$KUBERNETES_HOST kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
    ```

7. Create PKI Policy

    >
    > Check `sample/policy.hcl`
    >
   ```
   vault policy write --tls-skip-verify pki-policy policy.hcl
   ```

8. Authorize cert-manager

    ```
    vault write --tls-skip-verify auth/kubernetes/role/cert-manager \
    bound_service_account_names=cert-manager bound_service_account_namespaces='cert-manager' \
    policies=pki-policy \
    ttl=2h
    ```