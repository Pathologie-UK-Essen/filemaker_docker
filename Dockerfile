FROM ubuntu:20.04

# update all software download sources
RUN DEBIAN_FRONTEND=noninteractive \
    apt update && \
    apt full-upgrade -y && \
    DEBIAN_FRONTEND=noninteractive \
    apt install -y \
        sysstat \
        libaio1 \
        libicu66 \
        libuuid1 \
        libevent-2.1-7 \
        zlib1g \
        unzip \
        zip \
        openssl \
        libsasl2-2 \
        libfontconfig1 \
        libgomp1 \
        libcurl4 \
        curl \
        firewalld \
        apache2-bin \
        apache2-utils \
        libavahi-client3 \
        avahi-daemon \
        libvpx6 \
        libxpm4 \
        libxslt1.1 \
        openjdk-11-jre \
        libodbc1 \
        odbcinst1debian2 \
        policycoreutils \
        libbz2-1.0 \
        libfreetype6 \
        libtiff5 \
        libpng16-16 \
        libjpeg-turbo8 \
        liblzma5 \
        libwebpmux3 \
        libwebpdemux2 \
        libexpat1 \
        libxml2 \
        liblqr-1-0 \
        libdjvulibre21 \
        libopenexr24 \
        libilmbase24 \
        libomniorb4-2 \
        libc++1-12 \
        libboost-system1.71.0 \
        libboost-thread1.71.0 \
        libboost-chrono1.71.0 \
        libetpan20 \
        libantlr3c-3.4-0 \
        libpam0g \
        libomp5-12 \
        libheif1 \
        fonts-liberation2 \
        fonts-noto \
        fonts-takao \
        fonts-wqy-zenhei \
        fonts-baekmuk \
        nginx \
        logrotate \
        acl \
        libcurl3-gnutls \
        init && \
    apt --fix-broken install -y && \
    apt autoremove -y && \
    apt clean -y


# document the ports that should be
# published when filemaker server
# is installed
EXPOSE 80
EXPOSE 443
EXPOSE 2399
EXPOSE 5003

# copy assisted installer file
ENV ORIGIN "./Assisted Install.txt"
ENV TARGET "./Assisted Install.txt"
COPY ${ORIGIN} ${TARGET}

# create filemaker installer directory
#RUN mkdir fm_installer
WORKDIR /fm_installer

# download installer
RUN curl https://downloads.claris.com/esd/fms_19.5.2.201_Ubuntu20.zip -o fm_installer.zip && \
    unzip fm_installer.zip && \
    # install FileMaker
    FM_ASSISTED_INSTALL=/ apt install -y ./filemaker-server-19.5.2.201-amd64.deb && \
    # clean up
    cd .. && \
    rm -r fm_installer && \
    rm "./Assisted Install.txt" && \
    apt --fix-broken install -y && \
    apt autoremove -y && \
    apt clean -y

WORKDIR /

# when containers run, start this
# command as root to initialize
# user management
USER root
CMD ["/sbin/init"]