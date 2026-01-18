#!/bin/bash

# Define directory
DIR="/root"
if [ ! -w "$DIR" ]; then DIR="."; fi

# Create the Broken YAML (Using lowercase 'prefix')
cat <<EOF > $DIR/fix-ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: api-ingress
  namespace: default
spec:
  rules:
  - http:
      paths:
      - path: /api
        pathType: prefix   # <--- THE ERROR (Lowercase)
        backend:
          service:
            name: api-svc
            port:
              number: 8080
EOF

echo "------------------------------------------------"
echo "✅ Scenario Created at $DIR/fix-ingress.yaml"
echo "   - Status: File contains invalid pathType 'prefix'."
echo "   - Goal: Fix the capitalization error."
echo "------------------------------------------------"
