## Solution Guide

### 1. Check the pods in moon NS

```bash
k get all -n moon
NAME                 READY   STATUS    RESTARTS   AGE
pod/secret-handler   1/1     Running   0          6s
```

### 2. Create new secrets and add as env variables in the pod 

```bash
k create secret generic secret-handler --from-literal=user=test --from-literal=pass=pwd -n moon
secret/secret-handler created
```

```bash
vim /opt/course/14/secret-handler.yaml

  env:
    - name: SECRET1_USER
      valueFrom:
        secretKeyRef:
          name: secret-handler
          key: user
    - name: SECRET2_USER
      valueFrom:
        secretKeyRef:
          name: secret-handler
          key: pass
```

### 3. Create new secrets again and mount it inside the pod

```bash
k apply -f /opt/course/14/secret2.yaml
secret/secret2 created
``` 

```bash
k get secret -n moon
NAME             TYPE     DATA   AGE
secret-handler   Opaque   2      4m43s
secret2          Opaque   1      21s
```

```bash
vim /opt/course/14/secret-handler.yaml

spec:
  volumes:
  - name: secret-volume
    secret:
      secretName: secret2
  containers:
  - name: secret-handler
    image: bash:5.0.11
    args: ['bash', '-c', 'sleep 2d']
    volumeMounts:
    - mountPath: /tmp/secret2
      name: secret-volume
```

```bash
cp /opt/course/14/secret-handler.yaml /opt/course/14/secret-handler-new.yaml
```

```bash
k apply -f /opt/course/14/secret-handler-new.yaml
pod/secret-handler created
```

### 4. Verify the results

```bash
k get pods -n moon
NAME             READY   STATUS    RESTARTS   AGE
secret-handler   1/1     Running   0          4s
```