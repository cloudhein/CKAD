## Solution Guide

### 1. Check all the SA in monitoring NS

```bash
k get sa -n monitoring
NAME         SECRETS   AGE
admin-sa     0         3m49s
default      0         3m50s
monitor-sa   0         3m49s
wrong-sa     0         3m50s
```  
### 2. Check the Role & RoleBinding in monitoring NS

```bash
k get role,rolebinding -n monitoring
```

```bash
k get roles -n monitoring -o yaml
```

```bash
k get rolebindings -n monitoring -o yaml
```

### 3. Update the pod to use correct SA identity

```bash
k  get pod/metrics-pod -n monitoring -o yaml > monitor-pod.yaml

vim monitor-pod.yaml
# Edit the file to update serviceAccount and serviceAccountName to monitor-sa
spec:
    serviceAccount: monitor-sa  # Use the correct ServiceAccount
    serviceAccountName: monitor-sa # Use the correct ServiceAccount
```

```bash
k delete pod metrics-pod -n monitoring
pod "metrics-pod" deleted
```

```bash 
k apply -f monitor-pod.yaml 
pod/metrics-pod created
```