#!/bin/bash
# This shell script builds a new container image for the Gitea Operator
VERSION=1.3.1
QUAY_ID=gpte-devops-automation
#QUAY_USER=gpte-devops-automation+giteaoperatorbuild
CONTAINER_BUILT="false"

#echo "Logging in as ${QUAY_USER}. Please provide password when prompted."
#podman login -u ${QUAY_USER} quay.io
#if [[ "$?" != "0" ]];
#then
#  echo "Please ensure that QUAY_ID is logged into Quay successfully."
#  exit 1
#fi

# Build Operator Container Image
make podman-build IMG=quay.io/$QUAY_ID/gitea-operator:v${VERSION}

# Push Operator Image to Registry
make podman-push IMG=quay.io/$QUAY_ID/gitea-operator:v${VERSION}

# Make Operator Bundle
make bundle CHANNELS=stable DEFAULT_CHANNEL=stable VERSION=${VERSION} IMG=quay.io/$QUAY_ID/gitea-operator:v${VERSION}

# Build Operator Bundle Container Image
make bundle-build BUNDLE_CHANNELS=stable BUNDLE_DEFAULT_CHANNEL=stable VERSION=${VERSION} BUNDLE_IMG=quay.io/$QUAY_ID/gitea-operator-bundle:v${VERSION}

# Push Operator Bundle Container Image
podman push quay.io/$QUAY_ID/gitea-operator-bundle:v${VERSION}

# Build Catalog Image
opm index add \
    --bundles quay.io/$QUAY_ID/gitea-operator-bundle:v${VERSION} \
    --tag quay.io/$QUAY_ID/gitea-catalog:v${VERSION}

# Push Catalog Image
podman push quay.io/$QUAY_ID/gitea-catalog:v${VERSION}
