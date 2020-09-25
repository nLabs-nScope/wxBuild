FROM ubuntu:focal
MAINTAINER David Meyer <david@nscope.org>

ARG ARCH

RUN apt-get update && \
    apt-get install -y \
	git \
        zip \
	mingw-w64 \
	wget \
	nsis \
        make

RUN if [ $ARCH = "win32" ]; then \
        export TRIPLE="i686-w64-mingw32" \
    ; elif [ $ARCH = "win64" ]; then \
        export TRIPLE="x86_64-w64-mingw32" \
    ; else \
        >&2 echo "incompatible architecture" && exit 1 \
    ; fi && \
    update-alternatives --set $TRIPLE-gcc /usr/bin/$TRIPLE-gcc-posix && \
    update-alternatives --set $TRIPLE-g++ /usr/bin/$TRIPLE-g++-posix && \
    git clone https://github.com/nLabs-nScope/wxWidgets.git -b nScope && \
    cd wxWidgets && \
    wget -O config.guess 'http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD' && \
    wget -O config.sub 'http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=HEAD' && \
    mkdir build-local && \
    cd build-local && \
    ../configure --disable-mediactrl --disable-shared --build=x86_64-pc-linux-gnu --host=$TRIPLE \
        --enable-unicode --with-opengl --with-msw && \
    make install -j8

