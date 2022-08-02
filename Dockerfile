FROM ubuntu:20.04

# download and run installer
RUN DEBIAN_FRONTEND=noninteractive \
    apt update && \
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
        libcurl3-gnutls && \
    # clean up
    apt autoremove -y && \
    rm -rf /var/lib/apt/lists/*


# copy assisted installer file
ENV ORIGIN "./Assisted Install.txt"
ENV TARGET "/fm_installer/Assisted Install.txt"
COPY ${ORIGIN} ${TARGET}

COPY ./LicenseCert.fmcert /fm_installer/LicenseCert.fmcert


# ports exposed by filemaker server
EXPOSE 80
EXPOSE 443
EXPOSE 2399
EXPOSE 5003

WORKDIR /

USER root
CMD ["/sbin/init"]