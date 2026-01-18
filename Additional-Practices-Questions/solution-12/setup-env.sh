#!/bin/bash

# 1. Cleanup
kubectl delete deploy web-app --ignore-not-found
kubectl delete svc web-svc --ignore-not-found

# 2. Create the Deployment (The "Correct" Labels)
kubectl create deployment web-app --image=nginx:alpine --replicas=2
kubectl label deployment web-app app=webapp tier=frontend --overwrite

# 3. Create the Broken Service (The "Wrong" Selector)
# We manually create a service pointing to 'app=wrongapp'
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: web-svc
spec:
  selector:
    app: wrongapp   # <--- THE ERROR
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
EOF

echo "------------------------------------------------"
echo "✅ Scenario Ready!"
echo "   - Deployment 'web-app' (Labels: app=webapp)"
echo "   - Service 'web-svc' (Selector: app=wrongapp)"
echo "   - Goal: Fix the Service selector to match the Pods."
echo "------------------------------------------------"