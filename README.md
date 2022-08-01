# Building

## Prerequisites

- place a valid licence certificate (`LicenseCert.fmcert`) next to the Dockerfile


## Create Image

- set user, password and PIN in `Assisted Installer.txt`
- define FileMaker data as volume in `docker-compose.yaml` by either setting
  - an absolute path to an existing FileMake data directory
  - a volume name for a clean setup
- execute `docker compose up --detach`

## Access Admin console

The FileMaker admin console is available by calling `https://127.0.0.1:443/admin-console`.
