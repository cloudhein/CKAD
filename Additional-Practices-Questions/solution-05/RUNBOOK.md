## Solution Guide

### 1. Build a container image

```bash
podman build -t my-app:1.0 .
```

### 2. Save the image as a tarball
```bash
podman save my-app:1.0 --format oci-archive -o /root/my-app.tar 
```