## Solution Guide

### 1: Check all the pods -n pluto NS

```bash
k get all -n pluto
NAME           READY   STATUS    RESTARTS   AGE
pod/holy-api   1/1     Running   0          23s
```
### 2: Convert the pod to deployment and deploy the application 

```bash
touch /opt/course/9/holy-api-deployment.yaml
```

```bash
vim /opt/course/9/holy-api-deployment.yaml
```

```bash
k delete pod/holy-api -n pluto
pod "holy-api" deleted
```

```bash
k apply -f holy-api-deployment.yaml 
deployment.apps/holy-api created
```

### 3. Verify the result

```bash
k get all -n pluto
NAME                            READY   STATUS    RESTARTS   AGE
pod/holy-api-77fb9fb8db-2skvk   1/1     Running   0          51s
pod/holy-api-77fb9fb8db-lcvtk   1/1     Running   0          51s
pod/holy-api-77fb9fb8db-qj5cf   1/1     Running   0          51s

NAME                       READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/holy-api   3/3     3            3           51s

NAME                                  DESIRED   CURRENT   READY   AGE
replicaset.apps/holy-api-77fb9fb8db   3         3         3       51s
```