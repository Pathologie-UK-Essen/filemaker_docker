FROM ubuntu:20.04

# update all software download sources
RUN DEBIAN_FRONTEND=noninteractive \
    apt update && \
    apt full-upgrade -y && \
    DEBIAN_FRONTEND=noninteractive \
    apt install -y \
        curl \
        unzip \
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