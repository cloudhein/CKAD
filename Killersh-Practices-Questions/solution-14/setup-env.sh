#!/bin/bash

# 1. Clean up previous attempts
kubectl delete ns mars --ignore-not-found

# 2. Create the Namespace
kubectl create ns mars

# 3. Create the Deployment (The Backend)
# The pods here have the label "id: manager-api-pod"
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: manager-api-deployment
  namespace: mars
spec:
  replicas: 4
  selector:
    matchLabels:
      id: manager-api-pod
  template:
    metadata:
      labels:
        id: manager-api-pod
    spec:
      containers:
      - image: nginx:alpine
        name: manager-api-pod
        ports:
        - containerPort: 80
EOF

# 4. Create the Misconfigured Service
# ISSUE: The selector here tries to find "manager-api-deployment",
# but the pods are actually labeled "manager-api-pod".
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: manager-api-svc
  namespace: mars
spec:
  type: ClusterIP
  ports:
  - port: 4444
    targetPort: 80
  selector:
    id: manager-api-deployment
EOF

echo ""
echo "✅ Setup Complete."
echo "   - Namespace 'mars' created."
echo "   - Deployment 'manager-api-deployment' running (4 replicas)."
echo "   - Service 'manager-api-svc' created (but currently broken)."