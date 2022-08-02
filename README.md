# Building

## Introduction

Building a Dockerfile for FileMaker Server turned out to be challenging as the FileMaker installer failes on executing `systemctl` commands which is an previleged operation not available during build the process.
Therefore, building an valid image requires some manual steps violating best practices (see [FileMaker Documentation](https://support.claris.com/s/article/Running-FileMaker-Server-in-a-Docker-container)).       

## Prerequisites

- place a valid licence certificate (`LicenseCert.fmcert`) next to the Dockerfile
- set user, password and PIN in `Assisted Installer.txt`
- set the volume in `docker-compose.yaml` to either an existing FileMaker data directory or define a volume name


## Build image

- build initial image `docker build -t fmsdocker:prep .`
- install FileMaker into container
  - start container: `docker run --detach --hostname fms-docker --name fms-docker --privileged fmsdocker:prep`
  - log into container: `docker exec -it fms-docker /bin/bash`
  - download and installer filemaker server:
    ```
    cd fm_installer
    curl https://downloads.claris.com/esd/fms_19.5.2.201_Ubuntu20.zip -o fm_installer.zip
    unzip -n fm_installer.zip
    FM_ASSISTED_INSTALL=/fm_installer apt install -y ./filemaker-server-19.5.2.201-amd64.deb
    cd ..
    rm -r fm_installer
    ```
  - close docker session
  - commit changes into docker image `docker commit fms-docker fmsdocker:final`
  - stop container: `docker stop fms-docker`
  - remove container: `docker container rm fms-docker`

## Running the server

Execute `docker-compose up --detach`


## Access Admin console

The FileMaker admin console is available by calling `https://127.0.0.1:443/admin-console`.
