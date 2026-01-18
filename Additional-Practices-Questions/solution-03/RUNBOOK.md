## Solution Guide

### 1. Create a SA in audit NS

```bash
k create serviceaccount log-sa -n audit
serviceaccount/log-sa created
```

### 2. Create a Role & RoleBindings in audit NS

```bash
k create serviceaccount log-sa -n audit
serviceaccount/log-sa created
```

```bash
k apply -f pod-rolebind.yaml 
rolebinding.rbac.authorization.k8s.io/log-rb created
```

### 3. Recreate the pod and add new SA identity in the pod

```bash
k get pods -n audit -o yaml > log-collector-pod.yaml

vim log-collector-pod.yaml 
# Edit the file to add serviceAccountName: log-sa under spec:
spec:
    serviceAccountName: log-sa # Add this identity SA
```

```bash
k delete pod/log-collector -n audit
pod "log-collector" deleted
```

```bash
k apply -f log-collector-pod.yaml 
pod/log-collector created
```

