#!/bin/bash

export PATH="$(pwd)/bin:$PATH"

source set_env.sh

make opm

opm index add --permissive \
    --bundles quay.io/$QUAY_ID/gitea-operator-bundle:v${VERSION} \
    --tag quay.io/$QUAY_ID/gitea-catalog:v${VERSION}
