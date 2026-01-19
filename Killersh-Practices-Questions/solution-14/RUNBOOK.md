## Solution Guide

### 1. Check all the resources in mars NS

```bash
k get all -n mars
NAME                                          READY   STATUS    RESTARTS   AGE
pod/manager-api-deployment-5ccd487669-576rg   1/1     Running   0          15s
pod/manager-api-deployment-5ccd487669-6r4xn   1/1     Running   0          15s
pod/manager-api-deployment-5ccd487669-b76kc   1/1     Running   0          15s
pod/manager-api-deployment-5ccd487669-xjkhs   1/1     Running   0          15s

NAME                      TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
service/manager-api-svc   ClusterIP   10.133.176.163   <none>        4444/TCP   14s

NAME                                     READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/manager-api-deployment   4/4     4            4           15s

NAME                                                DESIRED   CURRENT   READY   AGE
replicaset.apps/manager-api-deployment-5ccd487669   4         4         4       15s
```

### 2. Check the labels of services and deployment and add the correct labels

#### Add the correct lables in the service 
```bash
k edit services/manager-api-svc -n mars 
service/manager-api-svc edited
```

### 3. Test the result with tempoary pod

```bash
k run pod --image=nginx:alpine -n mars
pod/pod created
```

```bash
k exec -it pod/pod -n mars -- curl manager-api-svc.mars:4444
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>

```
