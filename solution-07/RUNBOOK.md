## Solution Guide

1. Create a namespace

```bash
kubectl create namespace production
```

2. Run the cronjob

```bash
kubectl apply -f cronjob.yaml
```
***Run the cronjob manually***
```bash
kubectl create job manual-job --from=cronjob/log-cleaner -n production
job.batch/manual-job created
```

3. Verify the exection of cronjob

```bash
kubectl get all -n production
NAME                             READY   STATUS      RESTARTS   AGE
pod/log-cleaner-29474670-lqlh6   0/1     Completed   0          2m21s
pod/log-cleaner-29474670-z6dxw   0/1     Completed   0          2m31s
pod/manual-job-l7jjd             0/1     Completed   0          18s
pod/manual-job-nms2x             0/1     Completed   0          22s

NAME                        SCHEDULE       TIMEZONE   SUSPEND   ACTIVE   LAST SCHEDULE   AGE
cronjob.batch/log-cleaner   */30 * * * *   <none>     False     0        2m31s           7m47s

NAME                             STATUS     COMPLETIONS   DURATION   AGE
job.batch/log-cleaner-29474670   Complete   2/2           13s        2m31s
job.batch/manual-job             Complete   2/2           7s         22s
```