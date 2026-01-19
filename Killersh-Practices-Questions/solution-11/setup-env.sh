#!/bin/bash

# 1. Clean up previous attempts
kubectl delete ns moon --ignore-not-found
sudo rm -rf /opt/course/15

# 2. Create the Namespace
kubectl create ns moon

# 3. Create the directory for the exam files
sudo mkdir -p /opt/course/15
# Make it writable
sudo chmod 777 /opt/course/15

# 4. Create the source HTML file
cat <<EOF > /opt/course/15/web-moon.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Web Moon Webpage</title>
</head>
<body>
This is some great content.
</body>
</html>
EOF

# 5. Create the "Broken" Deployment
# It mounts a ConfigMap that does not exist yet
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-moon
  namespace: moon
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web-moon
  template:
    metadata:
      labels:
        app: web-moon
    spec:
      containers:
      - name: nginx
        image: nginx:alpine
        ports:
        - containerPort: 80
        volumeMounts:
        - name: html-volume
          mountPath: /usr/share/nginx/html
      volumes:
      - name: html-volume
        configMap:
          name: configmap-web-moon-html
EOF

echo ""
echo "✅ Setup Complete."
echo "   - Namespace 'moon' created."
echo "   - Deployment 'web-moon' created (and currently failing, as expected)."
echo "   - Source file available at: /opt/course/15/web-moon.html"