#!/bin/bash

# 1. Clean up previous attempts
kubectl delete ns neptune --ignore-not-found

# 2. Create the Namespace
kubectl create ns neptune

# 3. Create the ServiceAccount
# The question requires the Pods to run under this specific SA.
kubectl create serviceaccount neptune-sa-v2 -n neptune

echo ""
echo "✅ Setup Complete."
echo "   - Namespace 'neptune' created."
echo "   - ServiceAccount 'neptune-sa-v2' created."
echo "   - Ready for you to create the Deployment!"