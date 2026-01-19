## Solution Guide

### 1. Add an init container in existing deployment file

```bash
cp /opt/course/17/test-init-container.yaml .
```

```bash
k apply -f test-init-container.yaml 
deployment.apps/test-init-container created
```

### 2. Verify the results

```bash
k get pods -n mars -o wide
NAME                                       READY   STATUS    RESTARTS   AGE   IP            NODE          NOMINATED NODE   READINESS GATES
pod/test-init-container-565d6847fb-fg78j   1/1     Running   0          95s   10.253.2.24   133-worker2   <none>           <none>
```

```bash
k run pod --image=nginx:alpine -n mars 
pod/pod created
```

```bash
k exec -it pod/pod -n mars -- curl 10.253.2.24
check this out!
```