FROM arm64v8/fedora:30

ARG GST_VERSION="1.16.0"

# Install compiler etc.
RUN dnf install -y \
	autoconf \
	automake \
	bison \
	ca-certificates \
	cmake \
	dh-autoreconf \
	flex \
	gcc \
	gettext-devel \
	g++ \
	git \
	libmount-devel \
	libtool \
	nasm \
	which \
	yasm \
	glib2-devel

# Fetch and build GStreamer
RUN cd /tmp \
 && git clone -b $GST_VERSION \
    --depth 1 git://anongit.freedesktop.org/git/gstreamer/gstreamer \
 && cd gstreamer \
 && git checkout $GST_VERSION \
# This is a hack to get autogen to find the installed autoconf
 && ./autogen.sh \
    --with-autoconf $(which autoconf); exit 0
RUN cd /tmp \
 && cd gstreamer \
 && ./autogen.sh \
    --disable-gtk-doc \
 && make -j`nproc` \
 && make install \
 && cd .. \
 && rm -rvf /gstreamer


# Fetch and build gst-plugins-base
RUN cd /tmp \
 && git clone -b $GST_VERSION \
    --depth 1 git://anongit.freedesktop.org/git/gstreamer/gst-plugins-base \
 && cd gst-plugins-base \
 && git checkout $GST_VERSION \
# This is a hack to get autogen to find the installed autoconf
 && ./autogen.sh \
    --with-autoconf $(which autoconf); exit 0
RUN cd /tmp \
 && cd gstreamer \
 && ./autogen.sh \
    --disable-gtk-doc \
 && make -j`nproc` \
 && make install \
 && cd .. \
 && rm -rvf /gstreamer

# Fetch and build gst-plugins-good
RUN cd /tmp \
 && git clone -b $GST_VERSION \
    --depth 1 git://anongit.freedesktop.org/git/gstreamer/gst-plugins-good \
 && cd gst-plugins-good \
 && git checkout $GST_VERSION \
# This is a hack to get autogen to find the installed autoconf
 && ./autogen.sh \
    --with-autoconf $(which autoconf); exit 0
RUN cd /tmp \
 && cd gstreamer \
 && ./autogen.sh \
    --disable-gtk-doc \
 && make -j`nproc` \
 && make install \
 && cd .. \
 && rm -rvf /gstreamer

# Fetch and build gst-plugins-bad
RUN cd /tmp \
 && git clone -b $GST_VERSION \
    --depth 1 git://anongit.freedesktop.org/git/gstreamer/gst-plugins-bad \
 && cd gst-plugins-bad \
 && git checkout $GST_VERSION \
# This is a hack to get autogen to find the installed autoconf
 && ./autogen.sh \
    --with-autoconf $(which autoconf); exit 0
RUN cd /tmp \
 && cd gstreamer \
 && ./autogen.sh \
    --disable-gtk-doc \
 && make -j`nproc` \
 && make install \
 && cd .. \
 && rm -rvf /gstreamer

# Fetch and build gst-plugins-ugly
RUN cd /tmp \
 && git clone -b $GST_VERSION \
    --depth 1 git://anongit.freedesktop.org/git/gstreamer/gst-plugins-ugly \
 && cd gst-plugins-ugly \
 && git checkout $GST_VERSION \
# This is a hack to get autogen to find the installed autoconf
 && ./autogen.sh \
    --with-autoconf $(which autoconf); exit 0
RUN cd /tmp \
 && cd gstreamer \
 && ./autogen.sh \
    --disable-gtk-doc \
 && make -j`nproc` \
 && make install \
 && cd .. \
 && rm -rvf /gstreamer
