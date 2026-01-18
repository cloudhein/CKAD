## Setup Configuration

1. Create a namespace
```bash
kubectl create namespace production
```

2. Deploy the both application versions
```bash
kubectl apply -f web-app-v1.yaml 
deployment.apps/webapp-v1 created
```

```bash
kubectl apply -f web-app-v2.yaml 
deployment.apps/webapp-v2 created
```

## Solution Guide

1. Route both of application with canary deployment
```bash
kubectl edit deployment.apps/webapp-v1 -n production
spec:
  replicas: 4              # 4 Replicas (80% of total 5)
  selector:
    matchLabels:
      app: webapp

kubectl edit deployment.apps/webapp-v2 -n production
spec:
  replicas: 1             # 1 Replicas (20% of total 5)
  selector:
    matchLabels:
      app: webapp
```
