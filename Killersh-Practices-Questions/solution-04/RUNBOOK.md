## Solution Guide

### 1. Check the sa in neptune ns

```bash
k get sa -n neptune
NAME            SECRETS   AGE
default         0         2m22s
neptune-sa-v2   0         2m22s
```

### 2. Check the secrets in neptune ns

```bash 
k get secrets -n neptune
NAME                         TYPE                                  DATA   AGE
neptune-sa-v2-token-manual   kubernetes.io/service-account-token   3      3m20s
```

```bash
 k get secrets/neptune-sa-v2-token-manual -n neptune -o yaml | grep token
 ```

### 3. Write the base64 decoded token to file /opt/course/5/token

```bash
echo <token> | base64 -d > /opt/course/5/token
```


