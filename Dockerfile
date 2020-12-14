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
    ;

# Install linaro
ENV PATH=/usr/local/$LINARO_VERSION/bin:$PATH
RUN tar xvf $LINARO_VERSION.tar.xz -C /usr/local

COPY cross_file.txt /tmp/cross_file.txt

# Util linux ARGS
# https://github.com/karelzak/util-linux
ARG UTIL_LINUX_VERSION="2.35.1"

# Zlib ARGS
# https://github.com/madler/zlib/releases
ARG ZLIB_VERSION="1.2.11"

# OpenSSL ARGS
# https://github.com/openssl/openssl/releases
ARG OPENSSL_VERSION="1_0_2q"

# zlib
RUN curl -LO https://github.com/madler/zlib/archive/v$ZLIB_VERSION.tar.gz \
 && tar xf v$ZLIB_VERSION.tar.gz \
 && cd zlib-$ZLIB_VERSION \
 && export CC=aarch64-linux-gnu-gcc \
 && export C_INCLUDE_PATH=/usr/local/$LINARO_VERSION/include \
 && ./configure \
    --static \
    --archs="-fPIC" \
    --prefix=/usr/local/aarch64 \
 && make -j`nproc` \
 && make install \
 ;

# TODO figure out how to get openssl or gnutsl to compile so gstreamer will build libnice
# openssl
# RUN curl -LO https://github.com/openssl/openssl/archive/OpenSSL_$OPENSSL_VERSION.tar.gz \
#  && tar xf OpenSSL_$OPENSSL_VERSION.tar.gz \
#  && cd openssl-OpenSSL_$OPENSSL_VERSION \
#  && export CC=aarch64-linux-gnu-gcc \
#  && export C_INCLUDE_PATH=/usr/local/$LINARO_VERSION/include \
#  && ./Configure \
#     linux-aarch64 \
#     -march=armv8-a \
#     -fPIC \
#     --prefix=/usr/local/aarch64 \
#     --with-zlib-lib=/usr/local/aarch64 \
#  && make depend \
#  && make -j`nproc` \
#  && make install \
#  ;

# More info on environment settings can be found
# https://docs.rs/openssl/0.10.20/openssl/
ENV OPENSSL_STATIC=1 \
    OPENSSL_DIR=/usr/local/aarch64

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

ENV PKG_CONFIG_PATH=/usr/local/aarch64/lib/pkgconfig/
ENV LD_LIBRARY_PATH=/usr/local/aarch64/

# TODO: figure out why libmount version is UNKNOWN..0
RUN sed -i 's/UNKNOWN..0/2.23/g' /usr/local/aarch64/lib/pkgconfig/mount.pc

# gstreamer ARGS
# https://gstreamer.freedesktop.org/
ARG GSTREAMER_VERSION="1.18.2"

# gst-build, get and build all of the things
RUN curl -LO https://github.com/GStreamer/gst-build/archive/$GSTREAMER_VERSION.tar.gz \
 && tar xvf $GSTREAMER_VERSION.tar.gz  \
 && cd gst-build-$GSTREAMER_VERSION \
 && meson \
    --cross-file /tmp/cross_file.txt \
    --prefix=/usr/local/gst \
    -Ddisable_gtkdoc=true \
    _build \
    ;
RUN cd gst-build-$GSTREAMER_VERSION \
 && ninja -C _build \
 ;
RUN cd gst-build-$GSTREAMER_VERSION \
 && ninja -C _build install \
 ;

# clean up
RUN rm -rf *.gz

