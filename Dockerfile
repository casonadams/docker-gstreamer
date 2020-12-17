FROM fedora

WORKDIR /tmp


# Linaro ARGS
# https://releases.linaro.org/components/toolchain/binaries/
ARG LINARO_VERSION="gcc-linaro-7.5.0-2019.12-x86_64_aarch64-linux-gnu"
# This needs to be updated with the LINARO_VERSION!
RUN curl -LO https://releases.linaro.org/components/toolchain/binaries/latest-7/aarch64-linux-gnu/$LINARO_VERSION.tar.xz

RUN dnf -y update
RUN dnf -y install \
    autoconf \
    automake \
    bash-completion \
    bison \
    flex \
    g++ \
    gcc \
    gettext-devel \
    git \
    libtool \
    make \
    meson \
    xz \
    perl-FindBin \
    ;

# Install linaro
ENV PATH=$PATH:/usr/local/$LINARO_VERSION/bin
RUN tar xvf $LINARO_VERSION.tar.xz -C /usr/local

COPY cross_file.txt /tmp/cross_file.txt
# gstreamer ARGS
# https://gstreamer.freedesktop.org/
ARG GSTREAMER_VERSION="1.18.2"

# Util linux ARGS
# https://github.com/karelzak/util-linux
ARG UTIL_LINUX_VERSION="2.35.1"

# nasm
RUN git clone --depth=1 https://github.com/netwide-assembler/nasm.git \
 && cd nasm \
 && ./autogen.sh \
 && ./configure \
    --host=aarch64-linux-gnu \
    --prefix=/usr/local/aarch64 \
 && make -j`nproc` -i \
 && make install -i \
 ;

# util-linux libmount
RUN curl -LO https://github.com/karelzak/util-linux/archive/v$UTIL_LINUX_VERSION.tar.gz
RUN tar xvf v$UTIL_LINUX_VERSION.tar.gz \
 && cd util-linux-$UTIL_LINUX_VERSION \
 && ./autogen.sh \
 && ./configure \
    --host=aarch64-linux-gnu \
    --prefix=/usr/local/aarch64 \
 && make -j`nproc` \
 && make install \
 ;

# TODO: figure out why libmount version is UNKNOWN..0
RUN sed -i 's/UNKNOWN..0/2.23/g' /usr/local/aarch64/lib/pkgconfig/mount.pc

ENV PATH=$PATH:/usr/local/aarch64/bin

# gst-build, get and build all of the things
RUN curl -LO https://github.com/GStreamer/gst-build/archive/$GSTREAMER_VERSION.tar.gz \
 && tar xvf $GSTREAMER_VERSION.tar.gz  \
 && cd gst-build-$GSTREAMER_VERSION \
 && meson \
    --cross-file /tmp/cross_file.txt \
    --prefix=/usr/local/gst \
    _build \
    ;
RUN cd gst-build-$GSTREAMER_VERSION \
 && ninja -C _build \
 ;
RUN cd gst-build-$GSTREAMER_VERSION \
 && ninja -C _build install \
 ;

# # clean up
# RUN rm -rf *.gz

