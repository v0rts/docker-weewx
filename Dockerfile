FROM debian:buster-slim
MAINTAINER Tom Mitchell "tom@tom.org"
ENV WEEWX_VERSION=5.0.2-1
ENV WEEWX_ROOT=/home/weewx/weewx-data
ENV TZ=America/New_York
ENV PATH=/usr/bin:$PATH

RUN groupadd weewx && \
    useradd -m -g weewx -s /bin/bash weewx

RUN apt update
RUN apt install -y gcc wget gnupg python3 python3-paho-mqtt python3-pip rsync openssh-client tzdata rsyslog
RUN python3 -m pip install PyMySQL wheel CT3
RUN wget -qO - https://weewx.com/keys-old.html | gpg --dearmor --output /etc/apt/trusted.gpg.d/weewx.gpg

RUN echo "deb [arch=all] https://weewx.com/apt/python3 buster main" | \
    tee /etc/apt/sources.list.d/weewx.list

RUN mkdir -p /var/log/weewx
RUN chmod 775 /var/log/weewx
RUN chown weewx:weewx /var/log/weewx
RUN ln -s /etc/weewx/rsyslog.d/weewx.conf /etc/rsyslog.d
RUN /etc/init.d/rsyslog restart

#RUN apt update
#RUN DEBIAN_FRONTEND=noninteractive apt install -y weewx=$WEEWX_VERSION
COPY ./dist/weewx-$WEEWX_VERSION/ /tmp/
RUN DEBIAN_FRONTEND=noninteractive apt install -y /tmp/python3-weewx_"$WEEWX_VERSION"_all.deb
#RUN apt --fix-broken install -y

USER weewx
RUN mkdir -p $WEEWX_ROOT
COPY conf-fragments/ /tmp/conf-fragments/
RUN cat /tmp/conf-fragments/* >> /etc/weewx/weewx.conf

RUN /usr/bin/weectl station create --no-prompt
ADD ./bin/run.sh $WEEWX_ROOT/bin/run.sh
CMD $WEEWX_ROOT/bin/run.sh
user root
RUN chown -R weewx:weewx $WEEWX_ROOT
user weewx
WORKDIR $WEEWX_ROOT
