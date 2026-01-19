## Solution Guide

### 1. Check all the labels of the pods in the sun NS

```bash
k get all -n sun --show-labels
NAME                  READY   STATUS    RESTARTS   AGE   LABELS
pod/pod-messenger-1   1/1     Running   0          65s   type=messenger
pod/pod-messenger-2   1/1     Running   0          65s   type=messenger
pod/pod-runner-1      1/1     Running   0          65s   type=runner,type_old=messenger
pod/pod-runner-2      1/1     Running   0          65s   type=runner
pod/pod-runner-3      1/1     Running   0          65s   type=runner
pod/pod-runner-4      1/1     Running   0          65s   type=runner,type_old=messenger
pod/pod-test-1        1/1     Running   0          65s   type=test
pod/pod-worker-1      1/1     Running   0          65s   type=worker
pod/pod-worker-2      1/1     Running   0          65s   type=worker
pod/pod-worker-3      1/1     Running   0          65s   type=worker
pod/pod-worker-4      1/1     Running   0          65s   type=worker
pod/pod-worker-5      1/1     Running   0          65s   type=worker
pod/pod-worker-6      1/1     Running   0          65s   type=worker
pod/pod-worker-7      1/1     Running   0          65s   type=worker
pod/pod-worker-8      1/1     Running   0          64s   type=worker
pod/pod-worker-9      1/1     Running   0          64s   type=worker
```

### 2. Add a new label protected: true to Pods with an existing label type: worker or type: runner

```bash
k label pods -l type=worker protected=true -n sun
pod/pod-worker-1 labeled
pod/pod-worker-2 labeled
pod/pod-worker-3 labeled
pod/pod-worker-4 labeled
pod/pod-worker-5 labeled
pod/pod-worker-6 labeled
pod/pod-worker-7 labeled
pod/pod-worker-8 labeled
pod/pod-worker-9 labeled
```

```bash
k label pods -l type=runner protected=true -n sun
pod/pod-runner-1 labeled
pod/pod-runner-2 labeled
pod/pod-runner-3 labeled
pod/pod-runner-4 labeled
```

### 3. Verify the result

```bash
k get all -n sun --show-labels
NAME                  READY   STATUS    RESTARTS   AGE     LABELS
pod/pod-messenger-1   1/1     Running   0          4m58s   type=messenger
pod/pod-messenger-2   1/1     Running   0          4m58s   type=messenger
pod/pod-runner-1      1/1     Running   0          4m58s   protected=true,type=runner,type_old=messenger
pod/pod-runner-2      1/1     Running   0          4m58s   protected=true,type=runner
pod/pod-runner-3      1/1     Running   0          4m58s   protected=true,type=runner
pod/pod-runner-4      1/1     Running   0          4m58s   protected=true,type=runner,type_old=messenger
pod/pod-test-1        1/1     Running   0          4m58s   type=test
pod/pod-worker-1      1/1     Running   0          4m58s   protected=true,type=worker
pod/pod-worker-2      1/1     Running   0          4m58s   protected=true,type=worker
pod/pod-worker-3      1/1     Running   0          4m58s   protected=true,type=worker
pod/pod-worker-4      1/1     Running   0          4m58s   protected=true,type=worker
pod/pod-worker-5      1/1     Running   0          4m58s   protected=true,type=worker
pod/pod-worker-6      1/1     Running   0          4m58s   protected=true,type=worker
pod/pod-worker-7      1/1     Running   0          4m58s   protected=true,type=worker
pod/pod-worker-8      1/1     Running   0          4m57s   protected=true,type=worker
pod/pod-worker-9      1/1     Running   0          4m57s   protected=true,type=worker
```

### 4. Add an annotation protected='do not delete this pod' to the same pods

```bash
k annotate pods -l protected=true protected='do not delete this pod' -n sun
pod/pod-runner-1 annotated
pod/pod-runner-2 annotated
pod/pod-runner-3 annotated
pod/pod-runner-4 annotated
pod/pod-worker-1 annotated
pod/pod-worker-2 annotated
pod/pod-worker-3 annotated
pod/pod-worker-4 annotated
pod/pod-worker-5 annotated
pod/pod-worker-6 annotated
pod/pod-worker-7 annotated
pod/pod-worker-8 annotated
pod/pod-worker-9 annotated
```