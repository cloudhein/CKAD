#!/bin/bash

# 1. Clean up previous attempts
kubectl delete ns venus --ignore-not-found

# 2. Create the Namespace
kubectl create ns venus

# 3. Create the 'frontend' Deployment (Nginx)
# Label: id=frontend
kubectl create deployment frontend --image=nginx:alpine --replicas=5 -n venus
# We must manually label it to match the question's requirement (matchLabels: id=frontend)
kubectl patch deployment frontend -n venus --type='json' -p='[{"op": "add", "path": "/spec/template/metadata/labels/id", "value": "frontend"}]'

# 4. Create the 'api' Deployment (Apache/Httpd)
# Label: id=api
kubectl create deployment api --image=httpd:alpine --replicas=2 -n venus
# Manually label it (matchLabels: id=api)
kubectl patch deployment api -n venus --type='json' -p='[{"op": "add", "path": "/spec/template/metadata/labels/id", "value": "api"}]'

# 5. Create Services
# Frontend Service (Port 80)
kubectl expose deployment frontend -n venus --port=80 --target-port=80 --name=frontend

# API Service (Port 2222 -> Target 80)
# The question says "api:2222", so we map Service port 2222 to Container port 80
kubectl create service clusterip api -n venus --tcp=2222:80

echo ""
echo "✅ Setup Complete."
echo "   - Namespace 'venus' created."
echo "   - Deployment 'frontend' (5 replicas) created."
echo "   - Deployment 'api' (2 replicas) created."
echo "   - Services exposed (frontend:80, api:2222)."