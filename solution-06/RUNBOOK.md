## Configuration Setup

```bash
kubectl apply -f deployment.yaml 
deployment.apps/nginx-deployment created
```

*** Check the results **
```bash
kubectl get all
NAME                                    READY   STATUS    RESTARTS   AGE
pod/nginx-deployment-647677fc66-85mtf   1/1     Running   0          24s
pod/nginx-deployment-647677fc66-whf9t   1/1     Running   0          24s
pod/nginx-deployment-647677fc66-zhxhv   1/1     Running   0          24s

NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.133.0.1   <none>        443/TCP   45h

NAME                               READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/nginx-deployment   3/3     3            3           24s

NAME                                          DESIRED   CURRENT   READY   AGE
replicaset.apps/nginx-deployment-647677fc66   3         3         3       24s
```

## Solution Guide

***Update the app deployment in the nov2025 namespace with a maxSurge of 5% and a maxUnavailable of 2% and changing the image version to 1.13***
```bash
kubectl edit deployment/nginx-deployment
deployment.apps/nginx-deployment edited
```

***Check the rollout history***
```bash
 kubectl rollout history deployment
deployment.apps/nginx-deployment 
REVISION  CHANGE-CAUSE
1         <none>
2         <none>
```
***Rollback the app deployment to the previous version***
```bash
kubectl rollout undo deployment nginx-deployment
deployment.apps/nginx-deployment rolled back
```