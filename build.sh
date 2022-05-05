#!/bin/bash
# This shell script builds a new container image for the Gitea Operator
VERSION=1.3.2
QUAY_ID=kenmoini
#QUAY_USER=gpte-devops-automation+giteaoperatorbuild

#echo "Logging in as ${QUAY_USER}. Please provide password when prompted."
#podman login -u ${QUAY_USER} quay.io
#if [[ "$?" != "0" ]];
#then
#  echo "Please ensure that QUAY_ID is logged into Quay successfully."
#  exit 1
#fi

export PATH="$(pwd)/bin:$PATH"

# Build Operator Container Image
make podman-build IMG=quay.io/$QUAY_ID/gitea-operator:v${VERSION}

# Tag Image as latest
make podman-tag IMG=quay.io/$QUAY_ID/gitea-operator:v${VERSION} TAG=quay.io/$QUAY_ID/gitea-operator:latest

# Push Operator Image to Registry
make podman-push IMG=quay.io/$QUAY_ID/gitea-operator:v${VERSION}
make podman-push IMG=quay.io/$QUAY_ID/gitea-operator:latest

# Make Operator Bundle
make bundle CHANNELS=stable DEFAULT_CHANNEL=stable VERSION=${VERSION} IMG=quay.io/$QUAY_ID/gitea-operator:v${VERSION}

# Build Operator Bundle Container Image
make bundle-build BUNDLE_CHANNELS=stable BUNDLE_DEFAULT_CHANNEL=stable VERSION=${VERSION} BUNDLE_IMG=quay.io/$QUAY_ID/gitea-operator-bundle:v${VERSION}

# Tag the operator-bundle
make podman-tag IMG=quay.io/$QUAY_ID/gitea-operator-bundle:v${VERSION} TAG=quay.io/$QUAY_ID/gitea-operator-bundle:latest

# Push Operator Bundle Container Image
make podman-push IMG=quay.io/$QUAY_ID/gitea-operator-bundle:v${VERSION}
make podman-push IMG=quay.io/$QUAY_ID/gitea-operator-bundle:latest

# Build Catalog Image
opm index add --permissive \
    --bundles quay.io/$QUAY_ID/gitea-operator-bundle:v${VERSION} \
    --tag quay.io/$QUAY_ID/gitea-catalog:v${VERSION}

# Tag the catalog image
make podman-tag IMG=quay.io/$QUAY_ID/gitea-catalog:v${VERSION} TAG=quay.io/$QUAY_ID/gitea-catalog:latest

# Push Catalog Image
make podman-push IMG=quay.io/$QUAY_ID/gitea-catalog:v${VERSION}
make podman-push IMG=quay.io/$QUAY_ID/gitea-catalog:latest
