#!/bin/bash

export PATH="$(pwd)/bin:$PATH"

source set_env.sh

make opm

./bin/opm index add --permissive \
    --bundles quay.io/$QUAY_ID/gitea-operator-bundle:v${VERSION} \
    --tag quay.io/$QUAY_ID/gitea-catalog:v${VERSION}

# Tag the catalog image
make docker-tag IMG=quay.io/$QUAY_ID/gitea-catalog:v${VERSION} TAG=quay.io/$QUAY_ID/gitea-catalog:latest

# Push Catalog Image
make docker-push IMG=quay.io/$QUAY_ID/gitea-catalog:v${VERSION}
make docker-push IMG=quay.io/$QUAY_ID/gitea-catalog:latest
