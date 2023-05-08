#!/usr/bin/env bash

HOME=/home/weewx
echo "using $CONF"

CONF_FILE=$HOME/weewx-data/weewx.conf
PYTHONPATH=$PYTHONPATH:/home/weewx/weewx-data/bin

cd $HOME

while true; do weewxd $CONF_FILE > /dev/stdout; sleep 60; done
