#!/usr/bin/env sh

HOME=/home/weewx
echo "using $CONF"

CONF_FILE=$HOME/weewx.conf
PYTHONPATH=$PYTHONPATH:/root/.local/bin

cd $HOME

while true; do /root/.local/bin/weewxd $CONF_FILE > /dev/stdout; sleep 60; done
