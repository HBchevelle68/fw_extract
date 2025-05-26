# DumprX Docker Image

This repository builds a Docker image based on Ubuntu that installs and runs the [DumprX](https://github.com/DumprX/DumprX) tool along with a custom `extract.sh` script.

## Contents

- Uses `ubuntu:latest` as the base image
- Installs required system dependencies
- Clones and sets up the DumprX repository
- Copies in a custom `extract.sh` script
- Declares `/data` as a volume
- Sets `extract.sh` as the container entrypoint

## Requirements

- [Docker](https://docs.docker.com/get-docker/) installed on your system
- [DumprX repository](https://github.com/DumprX/DumprX)

## Build 
There is a simple `Makefile` that has the build and run commands for you. First build the basse image
```bash
make build
```

## Run
To run the image you will need a mobile firmware file (.zip, .tgz, etc.) and a output directory that you have access to.
```bash
make run FIRMWARE=/path/to/firmware OUTPUT=/path/to/output
```

Example:
```bash
make run FIRMWARE=~/Downloads/beryl_images_OS2.0.9.0.VOQCNXM_20250416.0000.00_15.0_cn_aab96de3d3.tgz OUTPUT=~/Downloads
```