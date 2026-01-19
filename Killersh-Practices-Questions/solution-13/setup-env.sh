#!/bin/bash

# 1. Clean up previous attempts
kubectl delete ns mars --ignore-not-found
sudo rm -rf /opt/course/17

# 2. Create the Namespace
kubectl create ns mars

# 3. Create the directory for the exam files
sudo mkdir -p /opt/course/17
# Make it writable
sudo chmod 777 /opt/course/17

# 4. Create the "Base" YAML file
# This is the starting point: an Nginx deployment with a volume, but NO content in it yet.
cat <<EOF > /opt/course/17/test-init-container.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: test-init-container
  namespace: mars
spec:
  replicas: 1
  selector:
    matchLabels:
      id: test-init-container
  template:
    metadata:
      labels:
        id: test-init-container
    spec:
      volumes:
      - name: web-content
        emptyDir: {}
      containers:
      - image: nginx:1.17.3-alpine
        name: nginx
        volumeMounts:
        - name: web-content
          mountPath: /usr/share/nginx/html
        ports:
        - containerPort: 80
EOF

echo ""
echo "✅ Setup Complete."
echo "   - Namespace 'mars' created."
echo "   - YAML file ready at: /opt/course/17/test-init-container.yaml"