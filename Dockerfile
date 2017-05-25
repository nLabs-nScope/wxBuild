FROM ubuntu
MAINTAINER David Meyer <david@nscope.org>

ARG ARCH
ARG WX_VER

COPY sources.list /etc/apt/sources.list

RUN apt-get update && \
    apt-get install -y \
        build-essential \
        wget \
	unzip \
    && \
    wget -qO- https://github.com/wxWidgets/wxWidgets/releases/download/v$WX_VER/wxWidgets-$WX_VER.tar.bz2 | tar xvj  && \
	cd wxWidgets-$WX_VER && \
	wget -O config.guess 'http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD' && \
	wget -O config.sub 'http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=HEAD' && \
	mkdir build-local && \
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
	    cpio \
	&& \
	cd / && \
	wget https://github.com/tpoechtrager/osxcross/archive/master.zip && \
	unzip master.zip && \
	rm master.zip && \
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
    ; fi && \
    cd /wxWidgets-$WX_VER/build-local && \
    ../configure --build=x86_64-pc-linux-gnu --host=$TRIPLE \
	--enable-unicode --with-opengl --with-$WXTOOLKIT $CONFIGFLAGS && \
    make install
