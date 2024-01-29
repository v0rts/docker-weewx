WEEWX_VERSION=5.0.0
docker pull mitct02/weewx:$WEEWX_VERSION

export TZ=America/New_York

docker run -it --rm \
    -e TZ=$TZ \
    -v $(pwd)/weewx.conf:/home/weewx/weewx-data/weewx.conf \
    -v $(pwd)/public_html:/home/weewx/weewx-data/public_html \
    -v $(pwd)/archive:/home/weewx/weewx-data/archive \
    mitct02/weewx:$WEEWX_VERSION
