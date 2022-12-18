FROM alpine:3.17.0
ENV WEEWX_VERSION=4.9.1
ENV HOME=/home/weewx
ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
#ENV PYTHONUNBUFFERED=1
RUN apk add --virtual .deps gcc zlib-dev jpeg-dev build-base linux-headers \
    && apk add --update --no-cache python3 python3-dev && ln -sf python3 /usr/bin/python \
# python3-configobj python3-serial python3-mysqldb python3-usb default-mysql-client sqlite3 curl rsync ssh tzdata wget gftp syslog-ng xtide xtide-data zlib1g-dev libjpeg-dev libfreetype6-dev
    && python3 -m ensurepip \
    && pip3 install --no-cache --upgrade Cheetah3 Pillow pyephem setuptools requests dnspython paho-mqtt configobj \
    && apk del .deps

#    RUN apk add --no-cache python3-tkinter-3.10.8-r1
#RUN apk add --no-cache python3-dev:3.9.13-alpine
#RUN apk add --no-cache py3-pip:21.3.1-r0
#RUN apk add --no-cache py3-pyserial:3.5-r0
#RUN apk add --no-cache py3-pyusb:1.1.1-r0
#RUN apk add --no-cache py3-pyephem

#RUN apt-get -y update
#
#RUN apt-get install -y apt-utils
#
#
## debian, ubuntu, mint, raspbian
## for systems that do not have python 3 installed (for example, ubuntu 18.04 and later):
#RUN apt-get install -y python3 python3-pip python3-configobj python3-serial python3-mysqldb python3-usb default-mysql-client sqlite3 curl rsync ssh tzdata wget gftp syslog-ng xtide xtide-data zlib1g-dev libjpeg-dev libfreetype6-dev
#RUN pip3 install Cheetah3 Pillow pyephem setuptools requests dnspython paho-mqtt configobj
#RUN ln -f -s /usr/bin/python3 /usr/bin/python
#RUN mkdir /var/log/weewx
## install weewx from source
#ADD dist/weewx-$WEEWX_VERSION /tmp/
#RUN cd /tmp && ./setup.py build
#RUN cd /tmp && echo "tom.org simulator\n1211, foot\n44.491\n-71.689\nn\nus\n3\n" | ./setup.py install
#
#RUN mkdir /home/weewx/tmp
#RUN mkdir /home/weewx/public_html
#
#RUN mkdir -p /etc/service/weewx
#
#ADD bin/run /etc/service/weewx/
#RUN chmod 755 /etc/service/weewx/run
#
#RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
#
#CMD ["/sbin/my_init"]
