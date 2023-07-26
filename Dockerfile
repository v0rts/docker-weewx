FROM alpine:3.17.0
MAINTAINER Tom Mitchell "tom@tom.org"
ENV VERSION=5.0.0b2
ENV WEEWX_HOME=/home/weewx
ENV TZ=America/New_York
ENV PATH=/usr/bin:$PATH
ENV CARGO_NET_GIT_FETCH_WITH_CLI=true

COPY conf-fragments/ /tmp/
COPY ./dist/weewx-$VERSION $WEEWX_HOME/tmp/weewx-$VERSION

RUN apk add --update --no-cache --virtual deps zlib-dev jpeg-dev python3-dev build-base linux-headers freetype-dev alpine-conf libffi-dev rust gcc musl-dev cargo pkgconfig libressl-dev git \
    && apk add --no-cache python3 py3-pyserial py3-usb py3-pymysql py3-six sqlite wget rsync openssh tzdata \
    && python -m ensurepip --upgrade \
    && pip3 install --upgrade pip \
    && pip3 install --user poetry \
    && ln -sf python3 /usr/bin/python \
    && pip3 install --user paho-mqtt configobj weewx \
    && adduser -D weewx \
    && mkdir -p /var/log/weewx /tmp/weewx /home/weewx/public_html /home/weewx/tmp \
#    && cd /home/weewx/tmp/weewx-$VERSION ; python3 -m pip install . \
    && /root/.local/bin/weectl station create --driver weewx.drivers.simulator --no-prompt --conf $WEEWX_HOME/weewx.conf \
    && cat /tmp/*.conf >> $WEEWX_HOME/weewx.conf \
    && apk del deps \
    && rm -rf /tmp/weewx \
    && rm -rf /tmp/*.conf

ADD ./bin/run.sh /home/weewx/bin/run.sh
WORKDIR $WEEWX_HOME
CMD $WEEWX_HOME/bin/run.sh
