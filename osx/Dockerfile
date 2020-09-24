FROM ubuntu:focal
MAINTAINER David Meyer <david@nscope.org>

COPY MacOSX10.11.sdk.tar.xz /

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y \
	git \
	wget \
	clang \
        make \
        cmake \
        libxml2-dev \
        libssl-dev \
        zlib1g-dev

RUN git clone https://github.com/nLabs-nScope/osxcross.git && \
    mv MacOSX10.11.sdk.tar.xz /osxcross/tarballs/ && \
    JOBS=8 UNATTENDED=1 OSX_VERSION_MIN=10.11 /osxcross/build.sh

RUN ln -sf /usr/bin/llvm-config-10 /usr/bin/llvm-config && \
    JOBS=8 /osxcross/build_compiler_rt.sh && \
    ln -s /osxcross/target/bin/* /usr/local/bin/


RUN git clone --recurse-submodules https://github.com/nLabs-nScope/wxWidgets.git && \
    cd wxWidgets && \
    wget -O config.guess 'http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD' && \
    wget -O config.sub 'http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=HEAD'


RUN export CC=x86_64-apple-darwin15-clang && \
    export CXX=x86_64-apple-darwin15-clang++ && \
    export CXXFLAGS="-std=c++11 -stdlib=libc++" && \
    export LDFLAGS="-stdlib=libc++" && \
    cd wxWidgets && \
    mkdir build-local && \
    cd build-local && \
    ../configure --disable-mediactrl --disable-shared --build=x86_64-pc-linux-gnu --host=x86_64-apple-darwin15 \
        --enable-unicode --with-opengl --with-cocoa --with-macosx-version-min=10.11 && \
    make install -j8

RUN mkdir -p /usr/lib/llvm-10/lib/clang/10.0.0/include && \
    mkdir -p /usr/lib/llvm-10/lib/clang/10.0.0/lib/darwin && \
    cp -rv /osxcross/build/compiler-rt/compiler-rt/include/sanitizer /usr/lib/llvm-10/lib/clang/10.0.0/include && \
    cp -v /osxcross/build/compiler-rt/compiler-rt/build/lib/darwin/*.a /usr/lib/llvm-10/lib/clang/10.0.0/lib/darwin && \
    cp -v /osxcross/build/compiler-rt/compiler-rt/build/lib/darwin/*.dylib /usr/lib/llvm-10/lib/clang/10.0.0/lib/darwin
