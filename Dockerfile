FROM alpine:3.17.0
MAINTAINER Tom Mitchell "tom@tom.org"

ENV WEEWX_VERSION=5.0.0
ENV HOME=/home/weewx
ENV TZ=America/New_York
ENV PATH=/usr/bin:$PATH

#wget http://www.weewx.com/downloads/released_versions/weewx-4.9.1.tar.gz -O /tmp/weewx.tgz \
#      && cd /tmp && tar zxvf /tmp/weewx*.tgz \
#      && cd weewx-* && python3 ./setup.py build && python3 ./setup.py install --no-prompt \

COPY conf-fragments/ /tmp/
RUN apk add --update --no-cache --virtual deps gcc zlib-dev jpeg-dev python3-dev build-base linux-headers freetype-dev py3-pip alpine-conf \
    && apk add --no-cache python3 py3-pyserial py3-usb py3-pymysql py3-six sqlite wget rsync openssh tzdata \
    && ln -sf python3 /usr/bin/python \
    && mkdir -p /var/log/weewx /tmp/weewx /home/weewx/public_html \
    && python3 -m pip install paho-mqtt configobj
RUN python3 -m pip install weewx

RUN weectl station create --driver weewx.drivers.simulator --no-prompt

RUN apk del deps \
    && rm -rf /tmp/weewx \
    && cat /tmp/*.conf >> $HOME/weewx-data/weewx.conf \
    && rm -rf /tmp/*.conf

CMD ["weewxd", "$HOME/weewx-data/weewx.conf"]
