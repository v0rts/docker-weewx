#!/usr/bin/env bash
REV=2
WEEWX_VERSION=5.1.0
IMAGE_VERSION=$WEEWX_VERSION-$REV
#docker build --no-cache -t mitct02/weewx:$VERSION .
BUILDKIT_COLORS="run=123,20,245:error=yellow:cancel=blue:warning=white" docker buildx build --platform linux/arm/v7,linux/arm64/v8,linux/amd64 -t mitct02/weewx:$IMAGE_VERSION .
#BUILDKIT_COLORS="run=123,20,245:error=yellow:cancel=blue:warning=white" docker buildx build --platform linux/arm/v7,linux/arm64/v8,linux/amd64 -t mitct02/weewx:$IMAGE_VERSION .
#docker pull mitct02/weewx:$IMAGE_VERSION
