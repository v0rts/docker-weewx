#!/usr/bin/env bash
REV=1
WEEWX_VERSION=5.2.0
IMAGE_VERSION=$WEEWX_VERSION-$REV
BUILDKIT_COLORS="run=123,20,245:error=yellow:cancel=blue:warning=white" \
  docker buildx build --push --platform linux/arm/v7,linux/arm64/v8,linux/amd64 \
  -t mitct02/weewx:$IMAGE_VERSION \.
if [ $? -eq 0 ]; then
    docker buildx imagetools create \
        -t mitct02/weewx:latest \
        mitct02/weewx:$IMAGE_VERSION
fi
