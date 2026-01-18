## Solution Guide

### 1. Check the broken deployment file and fix & create new deployment

```bash
cp broken-deploy.yaml fixed-deploy.yaml
```

```bash
k apply -f fixed-deploy.yaml
deployment.apps/broken-app created

vim fixed-deploy.yaml
# Update the file with the following changes:
# Change apiVersion from extensions/v1beta1 to apps/v1
# Add selector field under spec with matchLabels app: myapp
# Update replicas count to 2
```