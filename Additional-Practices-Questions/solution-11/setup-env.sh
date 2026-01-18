#!/bin/bash

# 1. Cleanup
kubectl delete deployment secure-app --ignore-not-found

# 2. Create the Initial Deployment
# We use busybox/sleep because standard Nginx might crash 
# if you change it to User 1000 (cannot bind port 80). 
# Busybox is safe for this specific test.
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: secure-app
  labels:
    app: secure
spec:
  replicas: 1
  selector:
    matchLabels:
      app: secure
  template:
    metadata:
      labels:
        app: secure
    spec:
      containers:
      - name: app
        image: busybox
        args:
        - sleep
        - "3600"
EOF

echo "------------------------------------------------"
echo "✅ Scenario Ready!"
echo "   - Deployment 'secure-app' created (using busybox)."
echo "   - Goal 1: Set Pod securityContext runAsUser: 1000"
echo "   - Goal 2: Set Container 'app' capability NET_ADMIN"
echo "------------------------------------------------"