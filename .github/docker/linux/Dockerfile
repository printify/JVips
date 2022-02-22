FROM centos:7.9.2009

# Set default build arguments.
ARG NODE_VERSION=10.x

# Set default user (overriden in the command line with Jenkins' actual user).
ARG UNAME=jenkins
ARG UID=1000
ARG GID=1000
ARG ARCH=""

# Set default environment variables.
ENV JAVA_HOME=/usr/lib/jvm/java-openjdk
ENV PATH="${OSX_CROSS_HOME}/bin:${PATH}"
ENV YUM_OPTIONS="-y --setopt=skip_missing_names_on_install=False"

RUN yum install ${YUM_OPTIONS} \
    centos-release-scl \
    https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

# Install system dependencies.
RUN yum install ${YUM_OPTIONS} \
    wget \
    git \
    cmake3 \
    meson \
    ninja-build \
    patch \
    clang \
    devtoolset-7-toolchain \
    nasm \
    yasm \
    autoconf \
    automake \
    libtool \
    diffutils \
    openssl-devel \
    expat-devel \
    zlib-devel \
    libxml2-devel \
    xz xz-devel \
    mpfr-devel \
    gmp-devel \
    libmpc-devel \
    gtk-doc \
    gobject-introspection gobject-introspection-devel \
    glib2 glib2-devel \
    java-1.8.0-openjdk-devel

RUN cd /tmp && \
    curl -L https://github.com/libvips/libvips/releases/download/v8.12.2/vips-8.12.2.tar.gz --output vips-8.12.2.tar.gz && \
    tar -zxvf vips-8.12.2.tar.gz && \
    rm -rf vips-8.12.2.tar.gz

RUN yum ${YUM_OPTIONS} install make gcc-c++ fftw3 orc libaom libexif giflib libimagequant libjpeg lcms2 libpng libwebp libwebp-devel

RUN cd /tmp/vips-8.12.2 && \
    ./autogen.sh && \
    ./configure --prefix=/usr && \
    make && \
    make DESTDIR=/tmp/build install && \
    cp -R /tmp/build/usr/* /usr/ && \
    cp -R /tmp/build/usr/lib/* /usr/lib64 && \
    rm -rf /tmp/{build,vips-8.12.2}

RUN ln -s /usr/bin/cmake3 /usr/bin/cmake

# Switch to a non-root user.
RUN groupadd -g $GID -o $UNAME
RUN useradd -l -m -u $UID -g $GID -o -s /bin/bash -d /home/$UNAME $UNAME

RUN echo 'for scl in /opt/rh/*/enable; do source $scl; done' >> /etc/profile.d/rhscl.sh

USER $UNAME

CMD bash -l -ex build.sh --with-linux --without-w64 --without-macos --arch "${ARCH}" --skip-test
