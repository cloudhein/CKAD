#!/bin/bash

# 1. Clean up previous attempts
kubectl delete ns moon --ignore-not-found
sudo rm -rf /opt/course/14

# 2. Create the Namespace
kubectl create ns moon

# 3. Create the directory for the exam files
sudo mkdir -p /opt/course/14
# Make it writable
sudo chmod 777 /opt/course/14

# 4. Create the initial "secret-handler.yaml"
# This is the "Starting State" of the Pod (before you edit it)
cat <<EOF > /opt/course/14/secret-handler.yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    id: secret-handler
    uuid: 1428721e-8d1c-4c09-b5d6-afd79200c56a
    red_ident: 9cf7a7c0-fdb2-4c35-9c13-c2a0bb52b4a9
    type: automatic
  name: secret-handler
  namespace: moon
spec:
  volumes:
  - name: cache-volume1
    emptyDir: {}
  - name: cache-volume2
    emptyDir: {}
  - name: cache-volume3
    emptyDir: {}
  containers:
  - name: secret-handler
    image: bash:5.0.11
    args: ['bash', '-c', 'sleep 2d']
    volumeMounts:
    - mountPath: /cache1
      name: cache-volume1
    - mountPath: /cache2
      name: cache-volume2
    - mountPath: /cache3
      name: cache-volume3
    env:
    - name: SECRET_KEY_1
      value: ">8\$kH#kj..i8}HImQd{"
    - name: SECRET_KEY_2
      value: "IO=a4L/XkRdvN8jM=Y+"
    - name: SECRET_KEY_3
      value: "-7PA0_Z]>{pwa43r)__"
EOF

# 5. Create the "secret2.yaml" file
# Contains the secret data for the second part of the question
cat <<EOF > /opt/course/14/secret2.yaml
apiVersion: v1
kind: Secret
metadata:
  name: secret2
  namespace: moon
type: Opaque
data:
  key: MTIzNDU2Nzg=
EOF
# (Note: MTIzNDU2Nzg= is base64 for '12345678')

# 6. Launch the initial Pod
kubectl apply -f /opt/course/14/secret-handler.yaml

echo ""
echo "✅ Setup Complete."
echo "   - Namespace 'moon' created."
echo "   - Pod 'secret-handler' is running (Initial State)."
echo "   - Files created in /opt/course/14/"