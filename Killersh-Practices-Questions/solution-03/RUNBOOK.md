## Solution Guide

### 1. Create a NS

```bash
k create ns neptune
namespace/neptune created
```

### 2. Create a job

```bash
k apply -f job.yaml 
job.batch/neb-new-job created
```

### 3. Verify the job & check the lables of pods

```bash
k get all -n neptune
NAME                    READY   STATUS      RESTARTS   AGE
pod/neb-new-job-9ql5j   0/1     Completed   0          21s
pod/neb-new-job-jl5nw   0/1     Completed   0          21s
pod/neb-new-job-wzszr   0/1     Completed   0          9s

NAME                    STATUS     COMPLETIONS   DURATION   AGE
job.batch/neb-new-job   Complete   3/3           17s        21s
```

```bash
k get pod -n neptune --show-labels | grep id=awesome-job

neb-new-job-9ql5j   0/1     Completed   0          74s   batch.kubernetes.io/controller-uid=526ffd9a-b219-4d5a-9d5d-144956b60e1c,batch.kubernetes.io/job-name=neb-new-job,controller-uid=526ffd9a-b219-4d5a-9d5d-144956b60e1c,id=awesome-job,job-name=neb-new-job
neb-new-job-jl5nw   0/1     Completed   0          74s   batch.kubernetes.io/controller-uid=526ffd9a-b219-4d5a-9d5d-144956b60e1c,batch.kubernetes.io/job-name=neb-new-job,controller-uid=526ffd9a-b219-4d5a-9d5d-144956b60e1c,id=awesome-job,job-name=neb-new-job
neb-new-job-wzszr   0/1     Completed   0          62s   batch.kubernetes.io/controller-uid=526ffd9a-b219-4d5a-9d5d-144956b60e1c,batch.kubernetes.io/job-name=neb-new-job,controller-uid=526ffd9a-b219-4d5a-9d5d-144956b60e1c,id=awesome-job,job-name=neb-new-job
```