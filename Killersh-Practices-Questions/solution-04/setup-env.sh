#!/bin/bash

# 1. Create the Namespace
kubectl create namespace neptune --dry-run=client -o yaml | kubectl apply -f -

# 2. Create the ServiceAccount
kubectl create serviceaccount neptune-sa-v2 -n neptune --dry-run=client -o yaml | kubectl apply -f -

# 3. Create the Secret attached to the ServiceAccount
# (Necessary because K8s 1.24+ does not auto-generate these anymore)
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: neptune-sa-v2-token-manual
  namespace: neptune
  annotations:
    kubernetes.io/service-account.name: neptune-sa-v2
type: kubernetes.io/service-account-token
EOF

# 4. Prepare the destination directory
sudo mkdir -p /opt/course/5
# Make it writable for the current user (assuming you aren't running as root)
sudo chmod 777 /opt/course/5

echo "✅ Environment created: Namespace 'neptune', SA 'neptune-sa-v2', and linked Secret."