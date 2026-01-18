## Setup Configuration

1. Create a namespace

```bash
kubectl create namespace meta
```

2. Create a deployment called dev-deployment in the meta ns

```bash
kubectl apply -f ~/dev-deployment.yaml -n meta
```

3. Check the logs 

```bash
kubectl logs -n meta -l app=dev-app -f
```

## Solution Guide

***kubectl apply -f deployment-reader-roles.yaml***
```bash
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: meta
  name: deployment-reader
rules:
- apiGroups: ["apps"] # "" indicates the core API group
  resources: ["deployments"]
  verbs: ["get", "watch", "list"]
```

***kubectl apply -f deployment-role-bindings.yaml***
```bash
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: read-deployments-binding
  namespace: meta
subjects:
# You can specify more than one "subject"
- kind: ServiceAccount
  name: default # "name" is case sensitive
  apiGroup: ""
roleRef:
  # "roleRef" specifies the binding to a Role / ClusterRole
  kind: Role #this must be Role or ClusterRole
  name: deployment-reader # this must match the name of the Role or ClusterRole you wish to bind to
  apiGroup: rbac.authorization.k8s.io
```

***Verify the solution by checking if the default service account in the meta namespace can list deployments***

```bash
kubectl auth can-i list deployments --as=system:serviceaccount:meta:default -n meta
yes
```


