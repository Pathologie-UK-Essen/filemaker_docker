# Building

## Introduction

Building a Dockerfile for FileMaker Server turned out to be challenging as the FileMaker installer fails on executing `systemctl` commands which is an previleged operation not available during the build  process.
Therefore, building an valid image requires some manual steps violating best practices (see [FileMaker Documentation](https://support.claris.com/s/article/Running-FileMaker-Server-in-a-Docker-container-for-Ubuntu-20-04)).       

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
    curl https://downloads.claris.com/esd/fms_19.5.4.400_Ubuntu20.zip -o fm_installer.zip
    unzip -n fm_installer.zip
    FM_ASSISTED_INSTALL=/fm_installer apt install -y ./filemaker-server-19.5.4.400-amd64.deb
    cd ..
    rm -r fm_installer
    ```
  - close docker session
  - commit changes into docker image `docker commit fms-docker fmsdocker:config`
  - stop container: `docker stop fms-docker`
  - remove container: `docker container rm fms-docker`

## Configure server

It seems like not all configurations are saved within the Data folder. Therefore some configuration (e.g. activation of REST-API) maybe lost after restarting the docker images. To avoid this the initial configuration should be done first and commited into a final image

  - run unconfigured image: `docker-compose up --detach`
  - set configurations
  - save configurations: `docker commit filemaker-server fmsdocker:final`
  - `docker-compose down`
  - set image to `fmsdocker:final` in `docker-compose.yaml`

## Running the server

Execute `docker-compose up --detach`


## Access Admin console

The FileMaker admin console is available by calling `https://127.0.0.1:443/admin-console`.

## Known Issues

It seems like smtp user name and password for notifications are being lost after each reboot and need to reset.
Even when configured before creating the final image this data does not persist.