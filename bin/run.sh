#!/usr/bin/env sh

HOME=/root
WEEWX_ROOT=$HOME/weewx-data
CONF_FILE=$WEEWX_ROOT/weewx.conf

python3 -m venv weewx-venv
source weewx-venv/bin/activate

echo "HOME=$HOME"
echo "using $CONF_FILE"
echo "weewx is in $WEEWX_ROOT"

cd $WEEWX_ROOT

while true; do $WEEWX_ROOT/bin/weewxd $CONF_FILE > /dev/stdout; sleep 60; done
