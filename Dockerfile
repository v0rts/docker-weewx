FROM alpine:3.18.4
MAINTAINER Tom Mitchell "tom@tom.org"
ENV VERSION=5.0.0
ENV WEEWX_ROOT=/home/weewx/weewx-data
ENV TZ=America/New_York
ENV PATH=/usr/bin:$PATH

RUN addgroup weewx && \
    adduser -G weewx -D weewx

RUN apk add python3 python3-dev py3-pip gcc libc-dev libffi-dev rsync openssh-client rsync openssh-client && \
    python3 -m pip install pip --upgrade && \
    python3 -m pip install cryptography && \
    python3 -m pip install pip --upgrade && \
    python3 -m pip install cryptography && \
    python3 -m pip install paho-mqtt


USER weewx
COPY conf-fragments/ /tmp/

RUN python3 -m pip install weewx --user --no-warn-script-location && \
    ~/.local/bin/weectl station create --no-prompt && \
    cat /tmp/logging-stdout.conf >> $WEEWX_ROOT/weewx.conf
ADD ./bin/run.sh $WEEWX_ROOT/bin/run.sh
CMD $WEEWX_ROOT/bin/run.sh
WORKDIR $WEEWX_ROOT
