#!/usr/bin/env bash
VERSION=4.9.0-multi

docker buildx build --push --platform linux/arm/v7,linux/arm64/v8,linux/amd64 -t mitct02/weewx:$VERSION .
#docker push mitct02/weewx:$VERSION
#docker tag mitct02/weewx:$VERSION mitct02/weewx:latest
#docker push mitct02/weewx:latest
