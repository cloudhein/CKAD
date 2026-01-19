#!/bin/bash

# 1. Clean up
kubectl delete ns neptune --ignore-not-found

# 2. Create the Namespace
kubectl create ns neptune

# 3. Create Revision 1 (Working Base)
# We remove --record and create it normally
kubectl create deployment api-new-c32 --image=nginx:1.21-alpine -n neptune --replicas=2
# We manually add the annotation to simulate history
kubectl annotate deployment api-new-c32 kubernetes.io/change-cause="Initial version" -n neptune
echo "Waiting for Revision 1 to roll out..."
kubectl rollout status deployment api-new-c32 -n neptune

# 4. Create Revisions 2, 3, 4 (Working Updates)
# We mimic the exam output by setting the change-cause annotation manually
for i in {2..4}; do
  kubectl set env deployment/api-new-c32 update_id=$i -n neptune
  
  # This makes the history look like the exam question:
  kubectl annotate deployment api-new-c32 kubernetes.io/change-cause="kubectl edit deployment api-new-c32 --namespace=neptune" -n neptune --overwrite
  
  echo "Waiting for Revision $i to roll out..."
  kubectl rollout status deployment api-new-c32 -n neptune
done

# 5. Create Revision 5 (The Broken Update)
kubectl set image deployment/api-new-c32 nginx=nginx:very-wrong-tag-123 -n neptune
kubectl annotate deployment api-new-c32 kubernetes.io/change-cause="kubectl edit deployment api-new-c32 --namespace=neptune" -n neptune --overwrite

echo ""
echo "✅ Setup Complete."
echo "   - Deployment 'api-new-c32' created."
echo "   - 5 Revisions generated."
echo "   - The current state is broken (ImagePullBackOff)."