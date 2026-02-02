FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y build-essential git autoconf automake libtool libpopt-dev libconfig-dev libssl-dev libpulse-dev libavahi-client-dev libavahi-common-dev avahi-daemon avahi-utils libsoxr-dev libasound2-dev libsndfile1-dev libdaemon-dev libdbus-1-dev libsystemd-dev xmlto xsltproc pkg-config libmosquitto-dev && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/mikebrady/shairport-sync.git /shairport-sync

WORKDIR /shairport-sync

RUN autoreconf -fi && ./configure --with-pa --with-avahi --with-ssl=openssl --with-mqtt --without-alsa && make -j$(nproc) && make install

RUN useradd -m -u 1000 shairport && mkdir -p /var/run/shairport-sync && chown shairport:shairport /var/run/shairport-sync

USER shairport

EXPOSE 5000

ENTRYPOINT ["shairport-sync"]
CMD ["-v"]
