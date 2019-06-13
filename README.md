# docker-gstreamer

## Setup
### OSX Install Docker Desktop
- [Docker Desktop](https://www.docker.com/products/docker-desktop)

### Linux Install Docker and docker-compose
- [docker](https://docs.docker.com/install/linux/docker-ce/ubuntu/)
- [docker-compose](https://docs.docker.com/compose/install/)

## Build
- GST_VERSION to set which gstreamer version to build
  - default: 1.16.0

```bash
docker-compose build gstreamer -e GST_VERSION=1.16.0
```

## Usage
- Currently drops into a shell where GStreamer can be run
- Projects dir is a shared volume at runtime

```bash
docker-compose run gstreamer
```
