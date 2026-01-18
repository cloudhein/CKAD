## Setup Configuration

1. Create the namespace
```bash
kubectl create namespace nov2025
```

2. Create the initial deployment (1 replica, no extra labels yet)
```bash
kubectl create deployment nov2025-deployment --image=nginx --replicas=1 --port=8080 -n nov2025
```

## Solution Guide

1. Add the label func=webFrontEnd to the pod template metadata and scale the deployment to 4 replicas.
```bash
kubectl edit deployment.apps/nov2025-deployment -n nov2025
deployment.apps/nov2025-deployment edited
```

*** Check the results
```bash
kubectl get all -n nov2025 --show-labels
NAME                                      READY   STATUS    RESTARTS   AGE   LABELS
pod/nov2025-deployment-54d5d6b886-mtkbx   1/1     Running   0          68s   app=nov2025-deployment,func=webFrontEnd,pod-template-hash=54d5d6b886
pod/nov2025-deployment-54d5d6b886-ntmgw   1/1     Running   0          73s   app=nov2025-deployment,func=webFrontEnd,pod-template-hash=54d5d6b886
pod/nov2025-deployment-54d5d6b886-rt6vb   1/1     Running   0          73s   app=nov2025-deployment,func=webFrontEnd,pod-template-hash=54d5d6b886
pod/nov2025-deployment-54d5d6b886-xlgqp   1/1     Running   0          27s   app=nov2025-deployment,func=webFrontEnd,pod-template-hash=54d5d6b886

NAME                                 READY   UP-TO-DATE   AVAILABLE   AGE     LABELS
deployment.apps/nov2025-deployment   4/4     4            4           3m30s   app=nov2025-deployment

NAME                                            DESIRED   CURRENT   READY   AGE     LABELS
replicaset.apps/nov2025-deployment-54d5d6b886   4         4         4       73s     app=nov2025-deployment,func=webFrontEnd,pod-template-hash=54d5d6b886
replicaset.apps/nov2025-deployment-7f794b6fc6   0         0         0       3m30s   app=nov2025-deployment,pod-template-hash=7f794b6fc6
```
2. Create and deploy a service in namespace nov2025

```bash
kubectl apply -f service.yaml 
service/berry created
```

*** Check the results
```bash
kubectl get services -n nov2025
NAME    TYPE       CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
berry   NodePort   10.133.113.139   <none>        8080:31240/TCP   9s
```