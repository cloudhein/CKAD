#!/bin/bash

echo "Starting Exam Scenario Setup..."

# 1. Clean up old resources if they exist (to avoid errors)
kubectl delete ns monitoring --ignore-not-found

# 2. Create Namespace
kubectl create ns monitoring
echo "✅ Namespace 'monitoring' created."

# 3. Create ServiceAccounts
kubectl create sa wrong-sa -n monitoring
kubectl create sa monitor-sa -n monitoring
kubectl create sa admin-sa -n monitoring
echo "✅ ServiceAccounts created."

# 4. Create Roles
# (A) Weak Role
kubectl create role view-only -n monitoring --verb=get --resource=pods
# (B) Correct Role (The Target)
kubectl create role metrics-reader -n monitoring --verb=get,list --resource=pods,nodes
# (C) Distractor Role
kubectl create role full-access -n monitoring --verb=* --resource=*
echo "✅ Roles created."

# 5. Create RoleBindings
kubectl create rolebinding view-binding -n monitoring --role=view-only --serviceaccount=monitoring:wrong-sa
kubectl create rolebinding correct-binding -n monitoring --role=metrics-reader --serviceaccount=monitoring:monitor-sa
kubectl create rolebinding admin-binding -n monitoring --role=full-access --serviceaccount=monitoring:admin-sa
echo "✅ RoleBindings created."

# 6. Create the Broken Pod
kubectl run metrics-pod \
  --image=nginx:alpine \
  -n monitoring \
  --overrides='{ "spec": { "serviceAccountName": "wrong-sa" } }'

echo "✅ Pod 'metrics-pod' created (using wrong-sa)."
echo "------------------------------------------------"
echo "Setup Complete! You can now start the troubleshooting task."