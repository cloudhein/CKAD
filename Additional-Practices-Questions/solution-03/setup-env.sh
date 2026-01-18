#!/bin/bash

echo "Starting Exam Scenario Setup..."

# 1. Cleanup old resources
kubectl delete ns audit --ignore-not-found

# 2. Create Namespace
kubectl create ns audit
echo "✅ Namespace 'audit' created."

# 3. Create the Failing Pod
# We use a 'kubectl' image that tries to list pods every 5 seconds.
# Since it uses the 'default' ServiceAccount, it will fail with "Forbidden".
kubectl run log-collector \
  --image=bitnami/kubectl:latest \
  -n audit \
  --restart=Never \
  --command -- /bin/sh -c "while true; do echo 'Checking permissions...'; kubectl get pods; sleep 5; done"

echo "✅ Pod 'log-collector' created."
echo "------------------------------------------------"
echo "Setup Complete!"
echo "1. Run 'kubectl logs -n audit log-collector' to see the error."
echo "2. Create the missing RBAC (SA, Role, Binding) to fix it."