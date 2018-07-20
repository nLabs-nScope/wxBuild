FROM ubuntu:bionic
MAINTAINER David Meyer <david@nscope.org>

COPY MacOSX10.11.sdk.tar.xz /

RUN apt-get update && \
    apt-get install -y \
	git \
	npm \
	wget \
	clang \
	build-essential \
    && \
    git clone https://github.com/nLabs-nScope/osxcross.git && \
    mv MacOSX10.11.sdk.tar.xz /osxcross/tarballs/ && \
    UNATTENDED=1 /osxcross/build.sh OSX_VERSION_MIN=10.7 && \
    ln -s /osxcross/target/bin/* /usr/local/bin/ && \
    export TRIPLE="x86_64-apple-darwin15" && \
    export WXTOOLKIT="cocoa" && \
    export CC=x86_64-apple-darwin15-clang && \
    export CXX=x86_64-apple-darwin15-clang++ && \
    export CFLAGS="-stdlib=libc++" && \
    export CXXFLAGS="-std=c++11 -stdlib=libc++" && \
    export OBJCXXFLAGS="-stdlib=libc++" && \
    export LDFLAGS="-stdlib=libc++" && \
    git clone https://github.com/nLabs-nScope/wxWidgets.git -b nScope && \
    cd wxWidgets && \
    wget -O config.guess 'http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD' && \
    wget -O config.sub 'http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=HEAD' && \
    mkdir build-local && \
    cd build-local && \
    ../configure --disable-mediactrl --disable-shared --build=x86_64-pc-linux-gnu --host=$TRIPLE \
        --enable-unicode --with-opengl --with-$WXTOOLKIT --with-macosx-version-min=10.7 && \
    make install
