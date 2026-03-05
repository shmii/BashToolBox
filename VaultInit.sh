!#/bin/bash
export VAULT_ADDR=https://address.of.vault.server/
export VAULT_TOKEN=value-of-my-root-token-or-an-authorized-token
vault kv get const/environment/engine-name db/schema/tns-string | command