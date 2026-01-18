## Setup Configuration 

### 1. Setup Ingress Controller 

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm install nginx ingress-nginx/ingress-nginx
```

### 2. Verify the results

```bash
helm list -A
NAME            NAMESPACE       REVISION        UPDATED                                 STATUS          CHART                   APP VERSION
metrics-server  kube-system     1               2026-01-19 01:10:48.30382647 +0700 +07  deployed        metrics-server-3.13.0   0.8.0      
nginx           default         1               2026-01-19 02:07:44.265278057 +0700 +07 deployed        ingress-nginx-4.14.1    1.14.1   
```

## Solution Guide

### 1. Check the ingressclass(ingress controller) in k8s cluster

```bash
k get ingressclass 
NAME    CONTROLLER             PARAMETERS   AGE
nginx   k8s.io/ingress-nginx   <none>       51s
```

### 2. Create ingress rules 

```bash
k apply -f ingress.yaml
ingress.networking.k8s.io/web-ingress created
```

### 3. Check the service and deployment labels & selectors carefully

```bash
k get svc <svc-name> -o yaml
k get deploy <deploy-name> -o yaml
```

### 4. Verify from the service ip from testing pod

```bash
k exec -it pod -- curl <svc-ip-address>:8080
```

### 5. Check from ingress hostname

```bash
curl -H "Host: web.example.com" http://172.18.255.180
```