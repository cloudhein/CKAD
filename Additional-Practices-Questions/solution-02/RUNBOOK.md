## Solution Guide

### 1. Deploy the cronjob file

```bash
k apply -f cronjob.yaml 
cronjob.batch/backup-job created
```

### 2. Verify the cronjob

```bash
k get cronjob
NAME         SCHEDULE       TIMEZONE   SUSPEND   ACTIVE   LAST SCHEDULE   AGE
backup-job   */30 * * * *   <none>     False     0        <none>          10s
```
### 3. Verify to test the cronjob with manual job run (optional) 

```bash
k create job manual-job --from=cronjob/backup-job
job.batch/manual-job created
```

```bash
k get jobs
NAME         STATUS     COMPLETIONS   DURATION   AGE
manual-job   Complete   1/1           3s         10s
```