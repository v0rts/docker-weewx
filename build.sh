#!/usr/bin/env bash
VERSION=4.9.0b1

docker build --no-cache -t mitct02/weewx:$VERSION .
docker push mitct02/weewx:$VERSION
docker tag mitct02/weewx:$VERSION mitct02/weewx:latest
docker push mitct02/weewx:latest
