# Development Guide

## Prerequisites

- Podman

## Install needed binaries

```bash
make opm
make kustomize
make ansible-operator
```

## Modify build.sh

At the top of the `build.sh` file there are a few variables that will need to be changed to deploy to your container registries.

## Create container registries

Create a few container registries, eg at quay.io

- gitea-catalog
- gitea-operator
- gitea-operator-bundle

Make sure to log into quay.io via the command line's `podman login ...`

## Build and Push the containers

```
./build.sh
```
