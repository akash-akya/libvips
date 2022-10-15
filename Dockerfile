FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /libvips
COPY ./ /libvips

RUN \
  # Install dependencies
  apt-get update && \
  apt-get install -y \
  automake build-essential libgirepository1.0-dev \
  ninja-build python3 python3-pip python3-setuptools python3-wheel \
  gobject-introspection libglib2.0-dev libpng-dev \
  libjpeg-turbo8-dev libwebp-dev libtiff5-dev libgif-dev \
  libexif-dev libxml2-dev libpoppler-glib-dev swig \
  libpango1.0-dev libmatio-dev libopenslide-dev libcfitsio-dev \
  libgsf-1-dev fftw3-dev liborc-0.4-dev librsvg2-dev libimagequant-dev && \
  #
  # Install meson from pip since the one in apt repository is outdated
  pip3 install meson && \
  #
  # Build and install
  meson build --libdir=lib && \
  cd build && meson compile && meson install && \
  #
  # Cleanup
  cd / && rm -rf /libvips && \
  pip3 uninstall -y meson && \
  # TODO: should we keep these?
  apt-get remove -y automake build-essential ninja-build \
  python3-pip python3-setuptools python3-wheel && \
  apt-get autoremove -y && \
  apt-get autoclean && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /data
