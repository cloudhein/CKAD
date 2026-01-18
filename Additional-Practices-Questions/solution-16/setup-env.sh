#!/bin/bash

# 1. Cleanup
kubectl delete ns prod --ignore-not-found

# 2. Create Namespace
kubectl create ns prod

# 3. Create ResourceQuota
# We set generic limits: 2 CPU, 1Gi Memory
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ResourceQuota
metadata:
  name: compute-quota
  namespace: prod
spec:
  hard:
    limits.cpu: "2"
    limits.memory: "1Gi"
    pods: "4"
EOF

echo "------------------------------------------------"
echo "✅ Scenario Ready!"
echo "   - Namespace 'prod' created."
echo "   - ResourceQuota 'compute-quota' applied."
echo "   - Goal: Find the quota limits, then create a pod using 50% of them."
echo "------------------------------------------------"