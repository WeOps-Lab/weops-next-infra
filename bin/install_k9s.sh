#!/bin/bash
set -euo pipefail
TMP_DIR=$(mktemp -d weops-lite-XXX)
tar -zxf k9s/*.tar.gz -C $TMP_DIR
cp /tmp/k9s /usr/local/bin
alias_command="alias k9s='k9s --kubeconfig /etc/rancher/k3s/k3s.yaml'"

if ! grep -q "$alias_command" ~/.bashrc; then
    echo "$alias_command" >> ~/.bashrc
    echo "Alias added to ~/.bashrc"
else
    echo "Alias already exists in ~/.bashrc"
fi

rm -rf $TMP_DIR