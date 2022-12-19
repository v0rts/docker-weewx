FROM alpine:3.17.0
ENV WEEWX_VERSION=4.9.1
ENV HOME=/home/weewx

ADD dist/weewx-$WEEWX_VERSION /tmp/weewx/
COPY conf-fragments/ /tmp/
RUN apk add --update --no-cache gcc zlib-dev jpeg-dev build-base linux-headers freetype-dev \
    python3 python3-dev py3-pip py3-pyserial py3-usb py3-pymysql sqlite wget rsync openssh alpine-conf \
    && ln -sf python3 /usr/bin/python \
    && pip3 install --no-cache --upgrade Cheetah3 Pillow image pyephem setuptools requests dnspython paho-mqtt configobj \
    && apk del py3-pip \
    && cd /tmp/weewx \
    && python3 ./setup.py build \
    && python3 ./setup.py install --no-prompt \
    && mkdir -p /var/log/weewx /tmp/weewx /home/weewx/public_html \
    && rm -rf /tmp/weewx \
    && setup-timezone America/New_York \
    && cat /tmp/*.conf >> /home/weewx/weewx.conf \
    && sed -i -e s:unspecified:Simulator: /home/weewx/weewx.conf
CMD ["/home/weewx/bin/weewxd", "/home/weewx/weewx.conf"]
