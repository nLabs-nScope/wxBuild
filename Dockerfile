FROM ubuntu
MAINTAINER David Meyer <david@nscope.org>

ARG ARCH

COPY sources.list /etc/apt/sources.list

RUN export ARCH=$ARCH && \
    apt-get update && \
    apt-get install -y \
	git \
    && \
    if [ $ARCH = "win32" ] || [ $ARCH = "win64" ]; then \
        apt-get install -y \
            mingw-w64 \
        && \
        if [ $ARCH = "win32" ]; then \
            export TRIPLE="i686-w64-mingw32" \
        ; else \
            export TRIPLE="x86_64-w64-mingw32" \
        ; fi && \
        export WXTOOLKIT="msw" \
    ; elif [ $ARCH = "osx" ]; then \
	apt-get install -y \
	    clang \
	    libxml2-dev \
	    libssl-dev \
	    cmake \
	&& \
	export TRIPLE="x86_64-apple-darwin" && \
	export WXTOOLKIT="cocoa" && \
	export CC=x86_64-apple-darwin15-clang && \
	export CXX=x86_64-apple-darwin15-clang++ && \
	export CONFIGFLAGS=--with-macosx-version-min=10.7 \
    ; else \
        dpkg --add-architecture $ARCH && \
        apt-get update && \
        apt-get install -y \
            libgtk-3-dev:$ARCH \
            libgl1-mesa-dev:$ARCH \
            libglu1-mesa-dev:$ARCH \
            libtiff5-dev:$ARCH \
            libjpeg-dev:$ARCH \
        && \
        if [ $ARCH = "i386" ]; then \
            apt-get install -y \
                gcc-multilib \
                g++-multilib \
            && \
            export CFLAGS=-m32 CXXFLAGS=-m32 LDFLAGS=-m32 && \
            export TRIPLE="i386-linux-gnu" \
        ; elif [ $ARCH = "amd64" ]; then \
            apt-get install -y build-essential && \
            export TRIPLE="x86_64-linux-gnu" \
        ; elif [ $ARCH = "armel" ]; then \
                apt-get install -y \
                    crossbuild-essential-armel \
                && \
                export TRIPLE="arm-linux-gnueabi" \
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
        export WXTOOLKIT="gtk=3" \
    ; fi

