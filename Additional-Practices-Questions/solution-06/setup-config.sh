#!/bin/bash

# 1. Create Namespace
kubectl create ns production

# 2. Create the Existing Deployment (v1)
# Starts with 5 replicas (50%)
kubectl apply -f webapp-v1.yaml

# 3. Create the Service
# Selects ONLY 'app=webapp'
kubectl expose deployment webapp-v1 --name=webapp-svc --port=80 --target-port=80 --selector=app=webapp -n production

echo "------------------------------------------------"
echo "✅ Exam Scenario Ready in namespace 'production'!"
echo "   - Current State: 5 Replicas of v1"
echo "   - Goal: 80% v1 / 20% v2 (Total 10)"
echo "------------------------------------------------"