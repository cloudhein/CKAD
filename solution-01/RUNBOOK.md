## Solution Guide

1. Build the docker image

```bash
docker build -t devmaq:3.0 .
```
or

```bash 
podman build -t devmaq:3.0 . 
```

2. Export the Image: Using the tool of your choice, export the built container image in OCI-format and store it at **~/human-stork/devmac-3.0.tar**.

```bash
docker save devmaq:3.0 -o devmac-3.0.tar
```
or

```bash
podman save --format oci-archive -o ~/human-stork/devmac-3.0.tar devmaq:3.0
```