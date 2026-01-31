FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install build dependencies
RUN apt-get update && apt-get install -y \\
    build-essential \\
    git \\
    autoconf \\
    automake \\
    libtool \\
    libpopt-dev \\
    libconfig-dev \\
    libssl-dev \\
    libpulse-dev \\
    libavahi-client-dev \\
    libavahi-common-dev \\
    avahi-daemon \\
    avahi-utils \\
    libsoxr-dev \\
    libasound2-dev \\
    libsndfile1-dev \\
    libdaemon-dev \\
    libdbus-1-dev \\
    libsystemd-dev \\
    xmlto \\
    xsltproc \\
    pkg-config \\
  && rm -rf /var/lib/apt/lists/*

# Get Shairport Sync source
RUN git clone https://github.com/mikebrady/shairport-sync.git /shairport-sync

WORKDIR /shairport-sync

# Build AirPlay-1-only with PulseAudio
RUN autoreconf -fi && \
    ./configure \
      --with-pa \
      --with-avahi \
      --with-ssl=openssl \
      --without-alsa \
    && make -j$(nproc) && make install

# Create non-root user (UID 1000 so PulseAudio accepts the stream)
RUN useradd -m -u 1000 shairport && \
    mkdir -p /var/run/shairport-sync && chown shairport:shairport /var/run/shairport-sync

USER shairport

EXPOSE 5000

CMD ["shairport-sync", "-v"]
