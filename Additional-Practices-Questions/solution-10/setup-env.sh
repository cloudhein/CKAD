#!/bin/bash

# 1. Cleanup
kubectl delete deployment api-deploy --ignore-not-found

# 2. Create the Deployment
# We use a custom Nginx config to actually listen on 8080 and serve /ready
# This ensures the probe will actually PASS if you configure it correctly.
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-deploy
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
      - name: api-container
        image: nginx:alpine
        ports:
        - containerPort: 8080
        # Create a simple index.html at /ready to make the probe pass (200 OK)
        lifecycle:
          postStart:
            exec:
              command: ["/bin/sh", "-c", "mkdir -p /usr/share/nginx/html/ready && echo 'OK' > /usr/share/nginx/html/ready/index.html && sed -i 's/80;/8080;/' /etc/nginx/conf.d/default.conf && nginx -s reload"]
EOF

echo "------------------------------------------------"
echo "✅ Scenario Ready!"
echo "   - Deployment 'api-deploy' created."
echo "   - App is listening on port 8080."
echo "   - Path '/ready' returns 200 OK."
echo "   - Goal: Add ReadinessProbe to port 8080 path /ready"
echo "------------------------------------------------"