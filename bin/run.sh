#!/usr/bin/env sh

HOME=/home/weewx
WEEWX_ROOT=$HOME/weewx-data
CONF_FILE=$WEEWX_ROOT/weewx.conf

echo "HOME=$HOME"
echo "using $CONF_FILE"
echo "weewx is in $WEEWX_ROOT"
echo "TZ=$TZ"
cd $WEEWX_ROOT

while true; do
  . /home/weewx/weewx-venv/bin/activate
  python3 $HOME/weewx/src/weewxd.py $CONF_FILE > /dev/stdout
  sleep 60
done
