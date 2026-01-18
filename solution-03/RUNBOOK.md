## Setup Configuration

1. Create a secret

```bash
kubectl create secret generic db-credentials --from-literal=username=admin --from-literal=password=P@ssw0rd123 -n default
secret/db-credentials created
```

2. Create a pod and add secrets as env variables

```bash
kubectl apply -f pods.yaml 
pod/env-secret-pod created
```

3. Verify the results

```bash
kubectl exec env-secret-pod -- env

DB_USER=admin
DB_PASS=P@ssw0rd123
```