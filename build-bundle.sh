#!/bin/bash

mkdir bin
export PATH="$(pwd)/bin:$PATH"
echo $PATH

source set_env.sh

export OS=$(uname -s | tr '[:upper:]' '[:lower:]')
export ARCH=$(uname -m | sed 's/x86_64/amd64/')

curl -sSLo - https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize/v3.5.4/kustomize_v3.5.4_${OS}_${ARCH}.tar.gz | tar xzf - -C bin/
make opm
make ansible-operator

ls bin

make bundle-local CHANNELS=stable DEFAULT_CHANNEL=stable VERSION=${VERSION} IMG=quay.io/$QUAY_ID/gitea-operator:v${VERSION}

# Tag the catalog image
make docker-tag IMG=quay.io/$QUAY_ID/gitea-catalog:v${VERSION} TAG=quay.io/$QUAY_ID/gitea-catalog:latest

# Push Catalog Image
make docker-push IMG=quay.io/$QUAY_ID/gitea-catalog:v${VERSION}
make docker-push IMG=quay.io/$QUAY_ID/gitea-catalog:latest