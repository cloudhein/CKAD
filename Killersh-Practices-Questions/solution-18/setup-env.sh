#!/bin/bash

# 1. Clean up previous attempts
kubectl delete ns sun --ignore-not-found

# 2. Create the Namespace
kubectl create ns sun

# 3. Create Pods with various labels to simulate the exam scenario
# We use a loop and arrays to create many pods quickly

# List of labels to assign
labels=("type=runner,type_old=messenger" "type=worker" "type=worker" "type=worker" "type=test" "type=worker" "type=worker" "type=worker" "type=messenger" "type=runner" "type=messenger" "type=runner" "type=runner,type_old=messenger" "type=worker" "type=worker" "type=worker")

# Corresponding names (simplified for script, but unique)
names=("pod-runner-1" "pod-worker-1" "pod-worker-2" "pod-worker-3" "pod-test-1" "pod-worker-4" "pod-worker-5" "pod-worker-6" "pod-messenger-1" "pod-runner-2" "pod-messenger-2" "pod-runner-3" "pod-runner-4" "pod-worker-7" "pod-worker-8" "pod-worker-9")

# Loop to create pods
for i in "${!names[@]}"; do
  kubectl run ${names[$i]} --image=nginx:alpine --restart=Never -n sun --labels="${labels[$i]}"
done

echo ""
echo "✅ Setup Complete."
echo "   - Namespace 'sun' created."
echo "   - 16 Pods created with various 'type' labels."
echo "   - You are ready to label and annotate them!"