## Solution Guide

### 1. Add readiness probes in the existing deployment 

```bash
k edit deployment.apps/api-deploy 
deployment.apps/api-deploy edited
```
### 2. Verify the results

```bash
k rollout status deployment.apps/api-deploy
deployment "api-deploy" successfully rolled out
```

