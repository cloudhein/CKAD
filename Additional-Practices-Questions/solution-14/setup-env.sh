#!/bin/bash

# 1. Cleanup
kubectl delete deploy web-deploy --ignore-not-found
kubectl delete svc web-svc --ignore-not-found
kubectl delete ingress web-ingress --ignore-not-found

# 2. Create Backend Deployment
kubectl create deployment web-deploy --image=nginx:alpine --replicas=1
kubectl label deployment web-deploy app=web --overwrite

# 3. Create Backend Service (ClusterIP)
kubectl expose deployment web-deploy --name=web-svc --port=8080 --target-port=80 --selector=app=web

echo "------------------------------------------------"
echo "✅ Scenario Ready!"
echo "   - Service 'web-svc' listening on port 8080."
echo "   - Goal: Create Ingress for host 'web.example.com'."
echo "------------------------------------------------"