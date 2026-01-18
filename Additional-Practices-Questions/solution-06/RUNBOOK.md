## Solution Guide

### 1. Deploy the existing deployment (v1) to 80 percentage traffic

```bash
k scale deployment.apps/webapp-v1 --replicas=8 -n production
deployment.apps/webapp-v1 scaled
```

### 2. Create the new deployment (v2) to 20 percentage traffic

```bash
k get deployment.apps/webapp-v1 -n production -o yaml > webapp-v2.yaml

vim webapp-v2.yaml
```

```bash
k apply -f webapp-v2.yaml 
deployment.apps/webapp-v2 created
```

### 3. Verify the results

```bash
k get all -n production
NAME                             READY   STATUS    RESTARTS   AGE
pod/webapp-v1-6c4d84f8bf-8mckw   1/1     Running   0          4m22s
pod/webapp-v1-6c4d84f8bf-fk22b   1/1     Running   0          5m44s
pod/webapp-v1-6c4d84f8bf-jh4nt   1/1     Running   0          5m44s
pod/webapp-v1-6c4d84f8bf-q6jj8   1/1     Running   0          5m44s
pod/webapp-v1-6c4d84f8bf-s7d4z   1/1     Running   0          4m22s
pod/webapp-v1-6c4d84f8bf-scjxt   1/1     Running   0          5m44s
pod/webapp-v1-6c4d84f8bf-tzj2x   1/1     Running   0          4m22s
pod/webapp-v1-6c4d84f8bf-zq9nw   1/1     Running   0          5m44s
pod/webapp-v2-d59bc6b9d-b6xj9    1/1     Running   0          17s
pod/webapp-v2-d59bc6b9d-mgwxp    1/1     Running   0          17s

NAME                 TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
service/webapp-svc   ClusterIP   10.133.214.149   <none>        80/TCP    5m44s

NAME                        READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/webapp-v1   8/8     8            8           5m44s
deployment.apps/webapp-v2   2/2     2            2           17s

NAME                                   DESIRED   CURRENT   READY   AGE
replicaset.apps/webapp-v1-6c4d84f8bf   8         8         8       5m44s
replicaset.apps/webapp-v2-d59bc6b9d    2         2         2       17s
```