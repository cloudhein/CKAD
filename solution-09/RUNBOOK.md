## Solution Guide

#### 1. Deploy the winter pod
```bash
kubectl apply -f winter.yaml 
pod/winter created
```

#### 2. Reterieve all the application logs and store them in the file

```bash
kubectl logs pod/winter > /opt/ckadnov2025/log_Output.txt
```

### Setup configuraion for step 3

#### Create a namespace 
```bash
kubectl create namespace cpu-stress
namespace "cpu-stress" deleted
```
#### Deploy the cpu stress workload
```bash
kubectl apply -f cpu-stress-pod.yaml -n cpu-stress
```

#### To monitor the metrics of k8s components, metrics server must be installed in your k8s cluster

```bash
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm repo update
helm install metrics-server metrics-server/metrics-server \
  --namespace kube-system \
  --set args={--kubelet-insecure-tls}
```

##### Check the results of metrics server installation
```bash
helm list -A
NAME            NAMESPACE       REVISION        UPDATED                                 STATUS          CHART                   APP VERSION
metrics-server  kube-system     1               2026-01-16 08:41:06.213511243 +0700 +07 deployed        metrics-server-3.13.0   0.8.0      
```

#### 3. Write the name only of the pod that is consuming the most CPU to file 

##### Check the cpu usage of pods 
```bash
kubectl top pods -n cpu-stress
NAME       CPU(cores)   MEMORY(bytes)   
stress-1   1000m        0Mi             
stress-2   38m          0Mi  
```

##### Write the pod name consuming the most CPU to file
```bash
echo "stress-1" > /opt/ckadnov2025/pod.txt
```
