#!/bin/bash

export PATH="$(pwd)/bin:$PATH"

source set_env.sh

make opm
make kustomize
make ansible-operator

make bundle CHANNELS=stable DEFAULT_CHANNEL=stable VERSION=${VERSION} IMG=quay.io/$QUAY_ID/gitea-operator:v${VERSION}

# Tag the catalog image
make docker-tag IMG=quay.io/$QUAY_ID/gitea-catalog:v${VERSION} TAG=quay.io/$QUAY_ID/gitea-catalog:latest

# Push Catalog Image
make docker-push IMG=quay.io/$QUAY_ID/gitea-catalog:v${VERSION}
make docker-push IMG=quay.io/$QUAY_ID/gitea-catalog:latest