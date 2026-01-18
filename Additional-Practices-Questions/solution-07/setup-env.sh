#!/bin/bash

# 1. Setup Namespace
kubectl delete ns network-demo --ignore-not-found
kubectl create ns network-demo

# 2. Create Pods with WRONG Labels
# Frontend (Has label 'tier=front', but Policy wants 'role=frontend')
kubectl run frontend --image=nginx:alpine -n network-demo -l tier=front
# Backend (Has label 'tier=back', but Policy wants 'role=backend')
kubectl run backend --image=nginx:alpine -n network-demo -l tier=back --port=80
# Database (Has label 'tier=db', but Policy wants 'role=db')
kubectl run database --image=postgres:alpine -n network-demo -l tier=db --port=5432 --env="POSTGRES_PASSWORD=password"

# 3. Create NetworkPolicies (The Source of Truth)
# (A) Default Deny
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny
  namespace: network-demo
spec:
  podSelector: {}
  policyTypes:
  - Ingress
EOF

# (B) Allow Frontend -> Backend
# REQ: Dest needs 'role=backend', Source needs 'role=frontend'
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-frontend-backend
  namespace: network-demo
spec:
  podSelector:
    matchLabels:
      role: backend
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          role: frontend
    ports:
    - protocol: TCP
      port: 80
EOF

# (C) Allow Backend -> Database
# REQ: Dest needs 'role=db', Source needs 'role=backend'
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-backend-db
  namespace: network-demo
spec:
  podSelector:
    matchLabels:
      role: db
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          role: backend
    ports:
    - protocol: TCP
      port: 5432
EOF

echo "------------------------------------------------"
echo "✅ Lab Ready in namespace 'network-demo'"
echo "   - Pods created with 'tier=...' labels (Incorrect)"
echo "   - NetworkPolicies require 'role=...' labels"
echo "   - Connectivity is currently BLOCKED."
echo "------------------------------------------------"