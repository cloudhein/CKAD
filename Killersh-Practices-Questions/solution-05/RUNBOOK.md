## Solution Guide

### 1. Deploy the readinessprobe pod

```bash
k apply -f pod.yaml 
pod/pod6 created
```

### 2. Verify the result

```bash
k get all
NAME       READY   STATUS    RESTARTS   AGE
pod/pod6   1/1     Running   0          51s

NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.133.0.1   <none>        443/TCP   36m
``` 