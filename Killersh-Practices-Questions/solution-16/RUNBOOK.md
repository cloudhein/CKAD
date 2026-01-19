## Solution Guide

### 1. Check all the pods and services of venus NS and their labels

```bash
k get all -n venus
NAME                            READY   STATUS    RESTARTS   AGE
pod/api-5657b85fbf-hqwxl        1/1     Running   0          80s
pod/api-5657b85fbf-zj8bt        1/1     Running   0          75s
pod/frontend-746f5d47f5-2b66k   1/1     Running   0          80s
pod/frontend-746f5d47f5-5n8fz   1/1     Running   0          79s
pod/frontend-746f5d47f5-n9tdd   1/1     Running   0          80s
pod/frontend-746f5d47f5-nrvdq   1/1     Running   0          79s
pod/frontend-746f5d47f5-t69fp   1/1     Running   0          80s

NAME               TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
service/api        ClusterIP   10.133.120.32    <none>        2222/TCP   80s
service/frontend   ClusterIP   10.133.167.192   <none>        80/TCP     80s

NAME                       READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/api        2/2     2            2           80s
deployment.apps/frontend   5/5     5            5           80s

NAME                                  DESIRED   CURRENT   READY   AGE
replicaset.apps/api-5657b85fbf        2         2         2       80s
replicaset.apps/api-6f9c44c5d6        0         0         0       80s
replicaset.apps/frontend-6558b654c4   0         0         0       80s
replicaset.apps/frontend-746f5d47f5   5         5         5       80s
```

```bash
k get services -n venus --show-labels
NAME       TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE     LABELS
api        ClusterIP   10.133.120.32    <none>        2222/TCP   3m18s   app=api
frontend   ClusterIP   10.133.167.192   <none>        80/TCP     3m18s   app=frontend
```

```bash
k get deployment -n venus --show-labels
NAME       READY   UP-TO-DATE   AVAILABLE   AGE    LABELS
api        2/2     2            2           5m1s   app=api
frontend   5/5     5            5           5m1s   app=frontend
```

### 2. Create network policy 

```bash
k apply -f network-policy.yaml 
networkpolicy.networking.k8s.io/np1 created
```

### 3. Verify the results

```bash
k exec -it frontend-746f5d47f5-2b66k -n venus -- sh
/ # wget www.google.com
Connecting to www.google.com (142.250.204.132:80) #Not able to connect to google.com for network policy restriction

/ # wget api.venus:2222
Connecting to api.venus:2222 (10.133.120.32:2222)
saving to 'index.html'
index.html           100% |***************************************************************************************************************|   191  0:00:00 ETA
'index.html' saved
```