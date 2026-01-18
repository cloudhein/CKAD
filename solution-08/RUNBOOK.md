## Configuration Setup

```bash
kubectl create ns web
namespace/web created
```

## Solution Guide

```bash
kubectl apply -f redis-pod.yaml -n web
pod/cache created
```

