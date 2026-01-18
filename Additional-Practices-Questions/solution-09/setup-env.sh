#!/bin/bash

# 1. Cleanup
kubectl delete deployment app-v1 --ignore-not-found

# 2. Create the Initial Deployment (v1)
kubectl create deployment app-v1 --image=nginx:1.20 --replicas=3

# 3. Wait for it to be ready
echo "Waiting for pods to be ready..."
kubectl rollout status deployment/app-v1

echo "------------------------------------------------"
echo "✅ Scenario Ready!"
echo "   - Deployment 'app-v1' is running nginx:1.20"
echo "   - Goal: Update to 1.25 -> Rollback to 1.20"
echo "------------------------------------------------"