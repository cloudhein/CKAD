#!/bin/bash

# 1. Cleanup
kubectl delete deploy api-server --ignore-not-found
kubectl delete svc api-nodeport --ignore-not-found

# 2. Create the Deployment (The "Backend")
# We use a simple python server listening on 9090
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-server
  labels:
    app: api
spec:
  replicas: 2
  selector:
    matchLabels:
      app: api
  template:
    metadata:
      labels:
        app: api
    spec:
      containers:
      - name: python-api
        image: python:alpine
        command: ["/bin/sh", "-c"]
        args: ["echo 'Server running on 9090'; python3 -m http.server 9090"]
        ports:
        - containerPort: 9090
EOF

echo "------------------------------------------------"
echo "✅ Scenario Ready!"
echo "   - Deployment 'api-server' running on port 9090."
echo "   - Goal: Create Service 'api-nodeport' (Port 80 -> 9090)."
echo "------------------------------------------------"