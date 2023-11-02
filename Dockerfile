FROM alpine:3.18.4
MAINTAINER Tom Mitchell "tom@tom.org"
ENV VERSION=5.0.0
ENV WEEWX_ROOT=/root/weewx-data
ENV TZ=America/New_York
ENV PATH=/usr/bin:$PATH

COPY conf-fragments/ /tmp/
COPY ./dist/weewx-$VERSION $WEEWX_ROOT/tmp/weewx-$VERSION

RUN apk add python3 python3-dev py3-pip gcc libc-dev libffi-dev && \
    python3 -m venv weewx-venv && \
    source weewx-venv/bin/activate && \
    python3 -m pip install pip --upgrade && \
    python3 -m pip install cryptography && \
    pip3 install weewx && \
    weectl station create --no-prompt

ADD ./bin/run.sh $WEEWX_ROOT/bin/run.sh
CMD $WEEWX_ROOT/weewx-data/bin/run.sh
WORKDIR $WEEWX_ROOT
