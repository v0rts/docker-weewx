FROM alpine:3.17.0
MAINTAINER Tom Mitchell "tom@tom.org"

ENV WEEWX_VERSION=5.0.0
ENV WEEWX_HOME=/home/weewx
ENV TZ=America/New_York
ENV PATH=/usr/bin:$PATH

COPY conf-fragments/ /tmp/
RUN apk add --update --no-cache --virtual deps gcc zlib-dev jpeg-dev python3-dev build-base linux-headers freetype-dev py3-pip alpine-conf \
    && apk add --no-cache python3 py3-pyserial py3-usb py3-pymysql py3-six sqlite wget rsync openssh tzdata \
    && ln -sf python3 /usr/bin/python \
    && python3 -m pip install paho-mqtt configobj \
    && adduser -D weewx \
    && mkdir -p /var/log/weewx /tmp/weewx /home/weewx/public_html /home/weewx/weewx-data \
    && python3 -m pip install weewx \
    && weectl station create --driver weewx.drivers.simulator --no-prompt --conf $WEEWX_HOME/weewx-data/weewx.conf \
    && cat /tmp/*.conf >> $WEEWX_HOME/weewx-data/weewx.conf \
    && apk del deps \
    && rm -rf /tmp/weewx \
    && rm -rf /tmp/*.conf

CMD weewxd $WEEWX_HOME/weewx-data/weewx.conf
