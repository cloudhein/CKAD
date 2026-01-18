## Setup Configuration

1. Create a namespace

```bash
kubectl create ns quetzal
```

2. Run the **hotfix-deployment** running in namespace **quetzal**

```bash
kubectl apply -f ~/broker-deployment/hotfix-deployment.yaml -n quetzal
``` 

*** Check the results **
```bash
kubectl get all -n quetzal
NAME                                     READY   STATUS    RESTARTS   AGE
pod/hotfix-deployment-54fcdc58cd-lj2vl   1/1     Running   0          26s

NAME                                READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/hotfix-deployment   1/1     1            1           26s

NAME                                           DESIRED   CURRENT   READY   AGE
replicaset.apps/hotfix-deployment-54fcdc58cd   1         1         1       26s
```
## Solution Guide

***kubectl edit deployment/hotfix-deployment -n  quetzal***
```bash
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: hotfix
    spec:
      securityContext:
        runAsUser: 30000
      containers:
      - image: nginx:1.14.2
        imagePullPolicy: IfNotPresent
        name: hotfix-container
        ports:
        - containerPort: 80
          protocol: TCP
        securityContext:
          allowPrivilegeEscalation: false
```