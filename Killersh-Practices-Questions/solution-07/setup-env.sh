#!/bin/bash

# 1. Clean up previous attempts
kubectl delete ns pluto --ignore-not-found
sudo rm -rf /opt/course/9

# 2. Create the Namespace
kubectl create ns pluto

# 3. Create the directory for the exam files
sudo mkdir -p /opt/course/9
# Make it writable so you can edit files there without sudo
sudo chmod 777 /opt/course/9

# 4. Create the "Raw" Pod YAML file
# This matches the complex specs (Env vars, Volumes) described in the question
cat <<EOF > /opt/course/9/holy-api-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: holy-api
  namespace: pluto
  labels:
    id: holy-api
    name: holy-api
spec:
  containers:
  - name: holy-api-container
    image: nginx:1.17.3-alpine
    env:
    - name: CACHE_KEY_1
      value: "b&MTCi0=[T66RXm!jO@"
    - name: CACHE_KEY_2
      value: "PCAILGej5Ld@Q%{Q1=#"
    - name: CACHE_KEY_3
      value: "2qz-]2OJlWDSTn_;RFQ"
    volumeMounts:
    - mountPath: /cache1
      name: cache-volume1
    - mountPath: /cache2
      name: cache-volume2
    - mountPath: /cache3
      name: cache-volume3
  volumes:
  - emptyDir: {}
    name: cache-volume1
  - emptyDir: {}
    name: cache-volume2
  - emptyDir: {}
    name: cache-volume3
EOF

# 5. Create the initial Pod from that file
kubectl apply -f /opt/course/9/holy-api-pod.yaml

echo ""
echo "✅ Setup Complete."
echo "   - Namespace 'pluto' created."
echo "   - Pod 'holy-api' is running."
echo "   - Source file available at: /opt/course/9/holy-api-pod.yaml"