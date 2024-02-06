FROM debian:buster-slim
MAINTAINER Tom Mitchell "tom@tom.org"
ENV VERSION=5.0.0-1
ENV WEEWX_ROOT=/home/weewx/weewx-data
ENV TZ=America/New_York
ENV PATH=/usr/bin:$PATH

RUN groupadd weewx && \
    useradd -m -g weewx -s /bin/bash weewx

RUN apt update
RUN apt install -y gcc wget gnupg python3 python3-paho-mqtt python3-pip rsync openssh-client tzdata
RUN python3 -m pip install PyMySQL wheel
RUN wget -qO - https://weewx.com/keys-old.html | gpg --dearmor --output /etc/apt/trusted.gpg.d/weewx.gpg

RUN echo "deb [arch=all] https://weewx.com/apt/python3 buster main" | \
    tee /etc/apt/sources.list.d/weewx.list

RUN apt update
RUN DEBIAN_FRONTEND=noninteractive apt install -y weewx=$VERSION

USER weewx
RUN mkdir -p $WEEWX_ROOT
COPY conf-fragments/ /tmp/

RUN /usr/bin/weectl station create --no-prompt && \
    cat /tmp/logging-stdout.conf >> $WEEWX_ROOT/weewx.conf
ADD ./bin/run.sh $WEEWX_ROOT/bin/run.sh
CMD $WEEWX_ROOT/bin/run.sh
user root
RUN chown -R weewx:weewx $WEEWX_ROOT
user weewx
WORKDIR $WEEWX_ROOT
