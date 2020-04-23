# gstreamer-aarch64-builder

This is mostly just an example of how to cross complile gstreamer for aarch64 using the linaro toolchain
gstreamer files end up in `/usr/local/gst`
aarch64 files end up in `/usr/local/aarch64`

## Setup

- Install [podman](https://podman.io/)

## Build

```bash
podman build -f Dockerfile -t gstreamer-aarch64-builder .
```

## Usage

```bash
podman run -it gstreamer-aarch64-builder bash
```
