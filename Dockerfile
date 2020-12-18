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
ENV PATH=$PATH:/usr/local/$LINARO_VERSION/bin:/usr/local/aarch64/bin
RUN tar xvf $LINARO_VERSION.tar.xz -C /usr/local

# util-linux libmount
ARG UTIL_LINUX_VERSION="v2.36.1"
RUN git clone https://github.com/karelzak/util-linux.git \
 && cd util-linux \
 && git checkout $UTIL_LINUX_VERSION \
 && ./autogen.sh \
 && ./configure \
    --host=aarch64-linux-gnu \
    --prefix=/usr/local/aarch64 \
 && make -j`nproc` \
 && make install -i \
 ;

# nasm
ARG NASM_VERSION="nasm-2.15.05"
RUN git clone https://github.com/netwide-assembler/nasm.git \
 && cd nasm \
 && git checkout $NASM_VERSION \
 && ./autogen.sh \
 && ./configure \
    --host=aarch64-linux-gnu \
    --prefix=/usr/local/aarch64 \
 && make -j`nproc` -i \
 && make install -i \
 ;

# opus
ARG OPUS_VERSION="v1.3.1"
RUN git clone https://github.com/xiph/opus.git \
 && cd opus \
 && git checkout $OPUS_VERSION \
 && ./autogen.sh \
 && ./configure \
    --host=aarch64-linux-gnu \
    --prefix=/usr/local/aarch64 \
 && make -j`nproc` \
 && make install -i \
 ;

COPY cross_file.txt /tmp/cross_file.txt
 
# gst-build, get and build all of the things
ARG GSTREAMER_VERSION="1.18.2"
RUN git clone https://gitlab.freedesktop.org/gstreamer/gst-build.git \
 && cd gst-build \
 && git checkout $GSTREAMER_VERSION \
 && meson  \
    --strip \
    --cross-file /tmp/cross_file.txt \
    --prefix=/usr/local/gst \
    -Dauto_features=disabled \
    -Dgstreamer:tools=enabled \
    -Dbad=enabled \
    -Dgst-plugins-bad:opus=enabled \
    -Dgood=enabled \
    -Dbase=enabled \
    -Dgst-plugins-base:opus=enabled \
    _build \
    ;
RUN cd gst-build \
 && ninja -C _build \
 ;
RUN cd gst-build \
 && ninja -C _build install \
 ;

# # clean up
# RUN rm -rf *.gz

