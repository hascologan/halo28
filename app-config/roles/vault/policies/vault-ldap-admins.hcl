path "secrets/ldap-service-users" {
  capabilities = ["create", "update", "read", "list"]
}

path "secret/root-ca" {
  capabilities = ["read", "list"]
}
