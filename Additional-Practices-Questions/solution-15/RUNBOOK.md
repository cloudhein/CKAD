## Solution Guide

### 1. Deploy the broken ingress file

```bash
k apply -f fix-ingress.yaml 
The Ingress "api-ingress" is invalid: spec.rules[0].http.paths[0].pathType: Unsupported value: "prefix": supported values: "Exact", "ImplementationSpecific", "Prefix"
```

### 2. Fix the ingress file

```bash
vim fix-ingress.yaml
# Update the file with the following changes:
# Find out and fix the error
```
