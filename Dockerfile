FROM ubuntu:20.04

# create filemaker installer directory
WORKDIR /fm_installer

# copy assisted installer file
ENV ORIGIN "./Assisted Install.txt"
ENV TARGET "./Assisted Install.txt"
COPY ${ORIGIN} ${TARGET}

COPY ./LicenseCert.fmcert ./LicenseCert.fmcert

# download and run installer
RUN DEBIAN_FRONTEND=noninteractive \ 
    apt update && \
    DEBIAN_FRONTEND=noninteractive \
    apt install -y \
        curl \
        unzip \
        libcurl3-gnutls && \
    curl https://downloads.claris.com/esd/fms_19.5.2.201_Ubuntu20.zip -o fm_installer.zip && \
    unzip -n fm_installer.zip && \
    # install FileMaker
    DEBIAN_FRONTEND=noninteractive \
    FM_ASSISTED_INSTALL=/fm_installer \
    apt install -y \
        ./filemaker-server-19.5.2.201-amd64.deb && \
    # clean up
    apt autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    cd .. && \
    rm -r fm_installer
    

WORKDIR /

# ports exposed by filemaker server
EXPOSE 80
EXPOSE 443
EXPOSE 2399
EXPOSE 5003


# when containers run, start this
# command as root to initialize
# user management
USER fmserver