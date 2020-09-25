FROM ubuntu:focal
MAINTAINER David Meyer <david@nscope.org>

ARG ARCH

COPY sources.list /etc/apt/sources.list

RUN dpkg --add-architecture $ARCH && \
    apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y \
	git \
	wget \
        zip \
        make \
        dpkg-dev \
        libgtk-3-dev:$ARCH \
        libgl1-mesa-dev:$ARCH \
        libglu1-mesa-dev:$ARCH \
        libtiff5-dev:$ARCH \
        libjpeg-dev:$ARCH \
	libusb-1.0:$ARCH \
	libudev-dev:$ARCH \
    && \
    if [ $ARCH = "i386" ]; then \
    	apt-get install -y \
            gcc-multilib \
            g++-multilib \
      	&& \
        export CFLAGS=-m32 CXXFLAGS=-m32 LDFLAGS=-m32 && \
        export TRIPLE="i386-linux-gnu" \
    ; elif [ $ARCH = "amd64" ]; then \
        apt-get install -y \
	    build-essential \ 
	&& \
        export TRIPLE="x86_64-linux-gnu" \
    ; elif [ $ARCH = "armhf" ]; then \
        apt-get install -y \
            crossbuild-essential-armhf \
        && \
        export TRIPLE="arm-linux-gnueabihf"	\
    ; elif [ $ARCH = "arm64" ]; then \
        apt-get install -y \
            crossbuild-essential-arm64 \
        && \
        export TRIPLE="aarch64-linux-gnu" \
    ; else \
        >&2 echo "incompatible architecture" && exit 1 \
    ; fi && \
    export PKG_CONFIG_PATH=/usr/lib/$TRIPLE/pkgconfig/ && \
    git clone https://github.com/nLabs-nScope/wxWidgets.git -b nScope && \
    cd wxWidgets && \
    wget -O config.guess 'http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD' && \
    wget -O config.sub 'http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=HEAD' && \
    mkdir build-local && \
    cd build-local && \
    ../configure --disable-mediactrl --disable-shared --build=x86_64-pc-linux-gnu --host=$TRIPLE \
        --enable-unicode --with-opengl --with-gtk && \
    make install -j8

