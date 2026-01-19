## Solution Guide

### 1. Check the resources in moon NS (pod is in creating stage for being failed to mount configmap volume)

```bash
k get all -n moon
NAME                            READY   STATUS              RESTARTS   AGE
pod/web-moon-7cc576cc8b-gh86w   0/1     ContainerCreating   0          50s
pod/web-moon-7cc576cc8b-hbkcw   0/1     ContainerCreating   0          50s

NAME                       READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/web-moon   0/2     2            0           50s

NAME                                  DESIRED   CURRENT   READY   AGE
replicaset.apps/web-moon-7cc576cc8b   2         2         0       50s
```

```bash
k describe pod/web-moon-7cc576cc8b-gh86w -n moon

Events:
  Type     Reason       Age                  From               Message
  ----     ------       ----                 ----               -------
  Normal   Scheduled    2m24s                default-scheduler  Successfully assigned moon/web-moon-7cc576cc8b-gh86w to 133-worker3
  Warning  FailedMount  16s (x9 over 2m24s)  kubelet            MountVolume.SetUp failed for volume "html-volume" : configmap "configmap-web-moon-html" not found
```

### 2. Create a configmap

```bash
k create configmap configmap-web-moon-html --from-file=index.html=/opt/c
ourse/15/web-moon.html -n moon
configmap/configmap-web-moon-html created
```

```bash
k get configmap -n moon
NAME                      DATA   AGE
configmap-web-moon-html   1      55s
kube-root-ca.crt          1      5m32s
```

### 3. Do rollout restart to the application to load the configmap data

```bash
k rollout restart deployment.apps/web-moon -n moon
deployment.apps/web-moon restarted
```

### 4. Verify the results

```bash
k get all -n moon
NAME                            READY   STATUS    RESTARTS   AGE
pod/web-moon-696548d675-cztr8   1/1     Running   0          70s
pod/web-moon-696548d675-xzm29   1/1     Running   0          69s

NAME                       READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/web-moon   2/2     2            2           6m29s

NAME                                  DESIRED   CURRENT   READY   AGE
replicaset.apps/web-moon-696548d675   2         2         2       70s
replicaset.apps/web-moon-7cc576cc8b   0         0         0       6m29s
```