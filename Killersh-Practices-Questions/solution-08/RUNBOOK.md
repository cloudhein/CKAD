## Solution Gudie

### 1. Create a NS

```bash
k create ns pluto
namespace/pluto created
```

### 2. Create a pod

```bash
k apply -f pod.yaml 
pod/project-plt-6cc-api created
``` 

### 3. Create a servics

```bash
k expose pod project-plt-6cc-api --name=project-plt-6cc-svc --port=3333 
--target-port=80 -n pluto 
service/project-plt-6cc-svc exposed
```
 
### 4. Create a temp pod, call the services endpoint from it & write the response to the files

```bash
k run pod --image=nginx:alpine -n pluto
pod/pod created
```

```bash
k exec -it pod/pod -n pluto -- curl project-plt-6cc-svc.pluto:3333
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
```

```bash
k exec -it pod/pod -n pluto -- curl project-plt-6cc-svc.pluto:3333 > service_test.html
```

```bash
k logs pod/project-plt-6cc-api -n pluto > service_test.log
```