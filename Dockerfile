FROM alpine:3.17.0
MAINTAINER Tom Mitchell "tom@tom.org"
ENV VERSION=5.0.0b1
ENV WEEWX_HOME=/home/weewx
ENV TZ=America/New_York
ENV PATH=/usr/bin:$PATH

COPY conf-fragments/ /tmp/
#RUN apk add --update --no-cache --virtual deps zlib-dev jpeg-dev python3-dev build-base linux-headers freetype-dev alpine-conf libffi-dev rust cargo gcc musl-dev cargo pkgconfig python3-dev libressl-dev git \
#    && apk add --no-cache python3 py3-pyserial py3-usb py3-pymysql py3-six sqlite wget rsync openssh tzdata \
#    && python -m ensurepip --upgrade \
#    && pip3 install --upgrade pip \
#    && ln -sf python3 /usr/bin/python \
#    && export CARGO_NET_GIT_FETCH_WITH_CLI=true && python3 -m pip install cryptography \
#    && python3 -m pip install paho-mqtt configobj \
#    && adduser -D weewx \
#    && mkdir -p /var/log/weewx /tmp/weewx /home/weewx/public_html /home/weewx/weewx-data \
#    && python3 -m pip install weewx \
##    && mv /home/weewx/weewx-data/bin/ /home/weewx/ \
#    && weectl station create --driver weewx.drivers.simulator --no-prompt --conf $WEEWX_HOME/weewx-data/weewx.conf \
#    && cat /tmp/*.conf >> $WEEWX_HOME/weewx-data/weewx.conf \
#    && apk del deps \
#    && rm -rf /tmp/weewx \
#    && rm -rf /tmp/*.conf

COPY ./dist/weewx-$VERSION $WEEWX_HOME/tmp/weewx-$VERSION
RUN apk add --update --no-cache --virtual deps zlib-dev jpeg-dev python3-dev build-base linux-headers freetype-dev alpine-conf libffi-dev rust gcc musl-dev cargo pkgconfig libressl-dev git \
    && apk add --no-cache python3 py3-pyserial py3-usb py3-pymysql py3-six sqlite wget rsync openssh tzdata \
    && python -m ensurepip --upgrade \
    && pip3 install --upgrade pip \
    && ln -sf python3 /usr/bin/python \
    && export CARGO_NET_GIT_FETCH_WITH_CLI=true && python3 -m pip install cryptography \
    && python3 -m pip install paho-mqtt configobj \
    && adduser -D weewx \
    && mkdir -p /var/log/weewx /tmp/weewx /home/weewx/public_html /home/weewx/weewx-data /home/weewx/tmp \
    && cd /home/weewx/tmp/weewx-$VERSION ; python3 -m pip install . \
    && weectl station create --driver weewx.drivers.simulator --no-prompt --conf $WEEWX_HOME/weewx-data/weewx.conf \
    && cat /tmp/*.conf >> $WEEWX_HOME/weewx-data/weewx.conf \
    && apk del deps \
    && rm -rf /tmp/weewx \
    && rm -rf /tmp/*.conf

ADD ./bin/run.sh /home/weewx/bin/run.sh
WORKDIR $WEEWX_HOME/weewx-data
CMD /home/weewx/bin/run.sh
