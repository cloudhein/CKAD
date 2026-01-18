## Setup Configuration 

1. Deploy a php apache application
```bash
kubectl create deployment php-apache --image=nginx --replicas=1
```

2. Expose it using cluster ip
```bash
kubectl expose deployment php-apache --port=80
service/php-apache exposed
```

3. Create a broken manifest file for HPA
```bash
k apply -f broken-hpa-sample.yaml
error: resource mapping not found for name: "php-apache" namespace: "" from "hpa.yaml": no matches for kind "HorizontalPodAutoscaler" in version "autoscaling/v2beta1"
ensure CRDs are installed first
```

## Solution Guide

1. Fix the apiVersion in hpa.yaml from autoscaling/v2beta1 to autoscaling/v2
```bash
kubectl apply -f hpa.yaml
horizontalpodautoscaler.autoscaling/php-apache created
```

2. Verify the HPA is created successfully
```bash
kubectl get hpa
NAME         REFERENCE               TARGETS              MINPODS   MAXPODS   REPLICAS   AGE
php-apache   Deployment/php-apache   cpu: <unknown>/50%   1         5         0          14s
```