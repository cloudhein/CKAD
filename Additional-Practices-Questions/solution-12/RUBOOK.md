## Solution Guide

### Check the deployment and services lables and selectors carefully

```bash
k edit services/web-svc
```

### Verify the result from testing pod

```bash
k run pod --image=nginx:alpine

k exec -it pod -- curl web-svc:80
```
