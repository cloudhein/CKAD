#!/bin/bash

# 1. Clean up previous attempts
kubectl delete ns jupiter --ignore-not-found

# 2. Create the Namespace
kubectl create ns jupiter

# 3. Create the Apache Deployment
# We use specific labels (id: jupiter-crew) to match the exam question style
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: jupiter-crew-deploy
  namespace: jupiter
spec:
  replicas: 1
  selector:
    matchLabels:
      id: jupiter-crew
  template:
    metadata:
      labels:
        id: jupiter-crew
    spec:
      containers:
      - name: apache
        image: httpd:alpine
        ports:
        - containerPort: 80
EOF

# 4. Create the ClusterIP Service
# This is the "Before" state: It is currently Type=ClusterIP
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: jupiter-crew-svc
  namespace: jupiter
spec:
  type: ClusterIP
  selector:
    id: jupiter-crew
  ports:
  - name: 8080-80
    port: 8080
    targetPort: 80
    protocol: TCP
EOF

echo ""
echo "✅ Setup Complete."
echo "   - Namespace 'jupiter' created."
echo "   - Deployment 'jupiter-crew-deploy' running."
echo "   - Service 'jupiter-crew-svc' created (Type: ClusterIP)."