FROM arm32v7/ubuntu

ARG GST_VERSION="1.16.0"
ARG NPROC=8

ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true

RUN apt-get -y update \
 && apt-get install -y \
    --no-install-recommends \
    apt-utils

# Install compiler etc.
RUN apt-get install -y \
    --no-install-recommends \
    autoconf \
    automake \
    autopoint \
    bison \
    ca-certificates \
    flex \
    libtool \
    yasm \
    nasm \
    git-core \
    build-essential \
    gettext

# Install dependencies necessary to build GStreamer
RUN apt-get install -y \
    --no-install-recommends \
    libglib2.0-dev \
    libpthread-stubs0-dev \
    libssl-dev \
    liborc-dev \
    libmpg123-dev \
    libmp3lame-dev \
    libsoup2.4-dev \
    libshout3-dev \
    libpulse-dev

# Fetch and build GStreamer
RUN cd /tmp \
 && git clone -b $GST_VERSION --depth 1 git://anongit.freedesktop.org/git/gstreamer/gstreamer \
 && cd gstreamer \
 && git checkout $GST_VERSION \
 && ./autogen.sh \
    --disable-gtk-doc \
 && make -j $NPROC \
 && make install \
 && cd .. \
 && rm -rvf /gstreamer

# Fetch and build gst-plugins-base
RUN cd /tmp \
 && git clone -b $GST_VERSION --depth 1 git://anongit.freedesktop.org/git/gstreamer/gst-plugins-base \
 && cd gst-plugins-base \
 && git checkout $GST_VERSION \
 && ./autogen.sh \
    --disable-gtk-doc \
 && make -j $NPROC \
 && make install \
 && cd .. \
 && rm -rvf /gst-plugins-base

# Fetch and build gst-plugins-good
RUN cd /tmp \
 && git clone -b $GST_VERSION --depth 1 git://anongit.freedesktop.org/git/gstreamer/gst-plugins-good \
 && cd gst-plugins-good \
 && git checkout $GST_VERSION \
 && ./autogen.sh \
    --disable-gtk-doc \
 && make -j $NPROC \
 && make install \
 && cd .. \
 && rm -rvf /gst-plugins-good

# Fetch and build gst-plugins-bad
RUN cd /tmp \
 && git clone -b $GST_VERSION --depth 1 git://anongit.freedesktop.org/git/gstreamer/gst-plugins-bad \
 && cd gst-plugins-bad \
 && git checkout $GST_VERSION \
 && ./autogen.sh \
    --disable-gtk-doc \
 && make -j $NPROC \
 && make install \
 && cd .. \
 && rm -rvf /gst-plugins-bad

# Fetch and build gst-plugins-ugly
RUN cd /tmp \
 && git clone -b $GST_VERSION --depth 1 git://anongit.freedesktop.org/git/gstreamer/gst-plugins-ugly \
 && cd gst-plugins-ugly \
 && git checkout $GST_VERSION \
 && ./autogen.sh \
    --disable-gtk-doc \
 && make -j $NPROC \
 && make install \
 && cd .. \
 && rm -rvf /gst-plugins-ugly

# Do some cleanup
RUN apt-get clean \
 && apt-get autoremove -y
