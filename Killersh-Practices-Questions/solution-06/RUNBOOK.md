## Solution Guide

### 1. Check all the deployments in neptune

```bash
k get all -n neptune
NAME                               READY   STATUS         RESTARTS   AGE
pod/api-new-c32-76f4f47494-25c77   0/1     ErrImagePull   0          10s
pod/api-new-c32-779f786648-rplvf   1/1     Running        0          12s
pod/api-new-c32-779f786648-ww5h4   1/1     Running        0          11s

NAME                          READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/api-new-c32   2/2     1            2           43s

NAME                                     DESIRED   CURRENT   READY   AGE
replicaset.apps/api-new-c32-57dd85f759   0         0         0       24s
replicaset.apps/api-new-c32-5dc4c9795    0         0         0       43s
replicaset.apps/api-new-c32-6ccf7d898b   0         0         0       26s
replicaset.apps/api-new-c32-76f4f47494   1         1         0       10s
replicaset.apps/api-new-c32-779f786648   2         2         2       12s
```

### 2. Check all the deployment versions 

```bash
k rollout history deployment.apps/api-new-c32 -n neptune
deployment.apps/api-new-c32 
REVISION  CHANGE-CAUSE
1         Initial version
2         kubectl edit deployment api-new-c32 --namespace=neptune
3         kubectl edit deployment api-new-c32 --namespace=neptune
4         kubectl edit deployment api-new-c32 --namespace=neptune
5         kubectl edit deployment api-new-c32 --namespace=neptune
```

### 3. Rollback to stable version
```bash
k rollout undo deployment.apps/api-new-c32 -n neptune 
deployment.apps/api-new-c32 rolled back
```

```bash
k rollout history deployment.apps/api-new-c32 -n neptune
deployment.apps/api-new-c32 
REVISION  CHANGE-CAUSE
1         Initial version
2         kubectl edit deployment api-new-c32 --namespace=neptune
3         kubectl edit deployment api-new-c32 --namespace=neptune
5         kubectl edit deployment api-new-c32 --namespace=neptune
6         kubectl edit deployment api-new-c32 --namespace=neptune
```

```bash
k get all -n neptune
NAME                               READY   STATUS    RESTARTS   AGE
pod/api-new-c32-779f786648-rplvf   1/1     Running   0          5m6s
pod/api-new-c32-779f786648-ww5h4   1/1     Running   0          5m5s

NAME                          READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/api-new-c32   2/2     2            2           5m37s

NAME                                     DESIRED   CURRENT   READY   AGE
replicaset.apps/api-new-c32-57dd85f759   0         0         0       5m18s
replicaset.apps/api-new-c32-5dc4c9795    0         0         0       5m37s
replicaset.apps/api-new-c32-6ccf7d898b   0         0         0       5m20s
replicaset.apps/api-new-c32-76f4f47494   0         0         0       5m4s
replicaset.apps/api-new-c32-779f786648   2         2         2       5m6s
```

