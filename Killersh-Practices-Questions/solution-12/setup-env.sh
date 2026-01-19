#!/bin/bash

# 1. Clean up previous attempts
kubectl delete ns mercury --ignore-not-found
sudo rm -rf /opt/course/16

# 2. Create the Namespace
kubectl create ns mercury

# 3. Create the directory for the exam files
sudo mkdir -p /opt/course/16
# Make it writable
sudo chmod 777 /opt/course/16

# 4. Create the "Before" YAML file
# This Deployment logs to a file but has no way to view it easily yet.
cat <<EOF > /opt/course/16/cleaner.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cleaner
  namespace: mercury
spec:
  replicas: 2
  selector:
    matchLabels:
      id: cleaner
  template:
    metadata:
      labels:
        id: cleaner
    spec:
      volumes:
      - name: logs
        emptyDir: {}
      initContainers:
      - name: init
        image: bash:5.0.11
        command: ['bash', '-c', 'echo init > /var/log/cleaner/cleaner.log']
        volumeMounts:
        - name: logs
          mountPath: /var/log/cleaner
      containers:
      - name: cleaner-con
        image: bash:5.0.11
        args: ['bash', '-c', 'while true; do echo \`date\`: "remove random file" >> /var/log/cleaner/cleaner.log; sleep 1; done']
        volumeMounts:
        - name: logs
          mountPath: /var/log/cleaner
EOF

# 5. Apply the initial Deployment
kubectl apply -f /opt/course/16/cleaner.yaml

echo ""
echo "✅ Setup Complete."
echo "   - Namespace 'mercury' created."
echo "   - Deployment 'cleaner' running."
echo "   - Source YAML: /opt/course/16/cleaner.yaml"