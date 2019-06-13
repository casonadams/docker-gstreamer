# docker-gstreamer

## Setup
Install Docker Desktop (OSX)
[Docker Desktop](https://www.docker.com/products/docker-desktop)

Install Docker and docker-compose (Linux)
[docker](https://docs.docker.com/install/linux/docker-ce/ubuntu/)
[docker-compose](https://docs.docker.com/compose/install/)

## Build
- GST_VERSION to set which gstreamer version to build
  - default: "1.16.0"
- NPROC to set how many cores to use during compiletime (make -j $NPROC)
  - default: 8

```bash
docker-compose build gstreamer -e GST_VERSION="1.16.0" -e NPROC=8
```

## Usage
- Currently drops into a shell where GStreamer can be run
- Projects dir is a shared volume as runtime

```bash
docker-compose run gstreamer
```
