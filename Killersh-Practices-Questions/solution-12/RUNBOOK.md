## Solution Guide

### 1. Check the resources in mercury NS

```bash
k get all -n mercury
NAME                           READY   STATUS    RESTARTS   AGE
pod/cleaner-7c58f76486-6q846   1/1     Running   0          5m54s
pod/cleaner-7c58f76486-7jsmd   1/1     Running   0          5m54s

NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/cleaner   2/2     2            2           5m54s

NAME                                 DESIRED   CURRENT   READY   AGE
replicaset.apps/cleaner-7c58f76486   2         2         2       5m54s
```

### 2. Add the sidecar container and deploy it

```bash
vim /opt/course/16/cleaner-new.yaml

   initContainers:
      - name: logger-con
        image: busybox:1.31.0
        restartPolicy: Always
        command: ['bash', '-c', 'tail -f /var/log/cleaner/cleaner.log']
        volumeMounts:
        - name: logs
          mountPath: /var/log/cleaner
```

```bash
k apply -f /opt/course/16/cleaner-new.yaml 
deployment.apps/cleaner configured
```

#### The sidecar container is successfully deployed
```bash
k get all -n mercury
NAME                           READY   STATUS    RESTARTS   AGE
pod/cleaner-5b5b8b8b4f-9kxhx   2/2     Running   0          98s
pod/cleaner-5b5b8b8b4f-vb86h   2/2     Running   0          95s

NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/cleaner   2/2     2            2           15m

NAME                                 DESIRED   CURRENT   READY   AGE
replicaset.apps/cleaner-5b5b8b8b4f   2         2         2       98s
replicaset.apps/cleaner-6f68776788   0         0         0       4m30s
replicaset.apps/cleaner-7c58f76486   0         0         0       15m
```

#### Finally check the logs of the logging sidecar container:
```bash
k logs pod/cleaner-5b5b8b8b4f-vb86h -n mercury -c logger-con
init
Mon Jan 19 11:59:23 UTC 2026: remove random file
Mon Jan 19 11:59:24 UTC 2026: remove random file
Mon Jan 19 11:59:25 UTC 2026: remove random file
Mon Jan 19 11:59:26 UTC 2026: remove random file
```