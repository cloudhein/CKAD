## Setup Configuration

1. Create a deployment 
```bash
kubectl apply -f deployment.yaml
```
## Solution Guide

### 1. Create a secret
```bash
kubectl create secret generic db-credentials --from-literal=DB_USER=admin --from-literal=DB_PASS=Secret123! -n default
```
### 2. Update Deployment api-server to use the Secret via valueFrom.secretKeyRef

```bash
k edit deployment.apps/api-server

name: api-server
envFrom:
- secretRef:
    name: db-credentials
```

### 3. Verify the results

```bash
k get all 
NAME                              READY   STATUS    RESTARTS   AGE
pod/api-server-8657598cbf-2ghgv   1/1     Running   0          110s
pod/api-server-8657598cbf-4kwr4   1/1     Running   0          113s
pod/api-server-8657598cbf-nnv9k   1/1     Running   0          117s

NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.133.0.1   <none>        443/TCP   15m

NAME                         READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/api-server   3/3     3            3           6m39s

NAME                                    DESIRED   CURRENT   READY   AGE
replicaset.apps/api-server-584db66cbc   0         0         0       6m39s
replicaset.apps/api-server-8657598cbf   3         3         3       117s
```