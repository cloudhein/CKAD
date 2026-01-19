# CKAD Practice Questions 

---

## Table of Contents

- [Question 1 – Namespaces](#question-1)
- [Question 2 – Pods](#question-2)
- [Question 3 –  Job](#question-3)
- [Question 4 – ServiceAccount, Secret](#question-4)
- [Question 5 – ReadinessProbe](#question-5)
- [Question 6 – Deployment, Rollouts](#question-6)
- [Question 7 – Pod -> Deployment](#question-7)
- [Question 8 – Service, Logs](#question-8)
- [Question 9 – Working with Containers](#question-9)
- [Question 10 – Secret, Secret-Volume, Secret-Env](#question-10)
- [Question 11 – ConfigMap, Configmap-Volume](#question-11)
- [Question 12 – Logging sidecar](#question-12)
- [Question 13 – InitContainer](#question-13)
- [Question 14 – Service misconfiguration](#question-14)
- [Question 15 – Service ClusterIP->NodePort](#question-15)
- [Question 16 – NetworkPolicy](#question-16)
- [Question 17 – Requests and Limits, ServiceAccount](#question-17)
- [Question 18 – Labels, Annotations](#question-18)


---
<a id="question-3"></a>
## Question 3 –  Job

Solve this question on instance: ssh ckad7326

Team Neptune needs a Job template located at /opt/course/3/job.yaml. This Job should run image busybox:1.31.0 and execute sleep 2 && echo done. It should be in namespace neptune, run a total of 3 times and should execute 2 runs in parallel.

Start the Job and check its history. Each pod created by the Job should have the label id: awesome-job. The job should be named neb-new-job and the container neb-new-job-container.

---
<a id="question-4"></a>

## Question 4 – ServiceAccount, Secret

Solve this question on instance: ssh ckad7326

Team Neptune has its own ServiceAccount named neptune-sa-v2 in Namespace neptune. A coworker needs the token from the Secret that belongs to that ServiceAccount. Write the base64 decoded token to file /opt/course/5/token on ckad7326.

---

---
<a id="question-5"></a>

## Question 5 – ReadinessProbe

Solve this question on instance: ssh ckad5601

Create a single Pod named pod6 in Namespace default of image busybox:1.31.0. The Pod should have a readiness-probe executing cat /tmp/ready. It should initially wait 5 and periodically wait 10 seconds. This will set the container ready only if the file /tmp/ready exists.

The Pod should run the command touch /tmp/ready && sleep 1d, which will create the necessary file to be ready and then idles. Create the Pod and confirm it starts.

---
<a id="question-6"></a>

## Question 6 – Deployment, Rollouts

Solve this question on instance: ssh ckad7326

There is an existing Deployment named `api-new-c32` in Namespace `neptune`. A developer did make an update to the Deployment but the updated version never came online. Check the Deployment history and find a revision that works, then rollback to it. Could you tell Team Neptune what the error was so it doesn't happen again?

---
<a id="question-7"></a>

## Question 7 – Pod -> Deployment

Solve this question on instance: ssh ckad9043

In Namespace `pluto` there is single Pod named `holy-api`. It has been working okay for a while now but Team Pluto needs it to be more reliable.

Convert the Pod into a Deployment named `holy-api` with 3 replicas and delete the single Pod once done. The raw Pod template file is available at `/opt/course/9/holy-api-pod.yaml.`

In addition, the new Deployment should set `allowPrivilegeEscalation: false` and `privileged: false` for the security context on container level.

Please create the Deployment and save its yaml under `/opt/course/9/holy-api-deployment.yaml` on `ckad9043.`

---
<a id="question-8"></a>

## Question 8 – Service, Logs

Solve this question on instance: `ssh ckad9043`

Team Pluto needs a new cluster internal Service. Create a ClusterIP Service named `project-plt-6cc-svc` in Namespace `pluto.` This Service should expose a single Pod named `project-plt-6cc-api` of image `nginx:1.17.3-alpine`, create that Pod as well. The Pod should be identified by label `project: plt-6cc-api`. The Service should use tcp port redirection of `3333:80`.

Finally use for example `curl` from a temporary `nginx:alpine` Pod to get the response from the Service. Write the response into `/opt/course/10/service_test.html` on `ckad9043`. Also check if the logs of Pod `project-plt-6cc-api` show the request and write those into `/opt/course/10/service_test.log `on ckad9043.

---
<a id="question-9"></a>

## Question 9 – Working with Containers

Solve this question on instance: ssh ckad9043

There are files to build a container image located at /opt/course/11/image on ckad9043. The container will run a Golang application which outputs information to stdout. You're asked to perform the following tasks:

1. Change the Dockerfile: set ENV variable `SUN_CIPHER_ID` to hardcoded value `5b9c1065-e39d-4a43-a04a-e59bcea3e03f`

2. Build the image using `sudo docker`, tag it `registry.killer.sh:5000/sun-cipher:v1-docker` and push it to the registry

3. Build the image using `sudo podman`, tag it `registry.killer.sh:5000/sun-cipher:v1-podman` and push it to the registry

4. Run a container using `sudo podman`, which keeps running detached in the background, named `sun-cipher` using image `registry.killer.sh:5000/sun-cipher:v1-podman`

5. Write the logs your container `sun-cipher` produces into `/opt/course/11/logs` on ckad9043

---
<a id="question-10"></a>

## Question 10 – Secret, Secret-Volume, Secret-Env

Solve this question on instance: ssh ckad9043

You need to make changes on an existing Pod in Namespace `moon` called `secret-handler`. Create a new Secret `secret1` which contains `user=test` and `pass=pwd`. The Secret's content should be available in Pod secret-handler as environment variables `SECRET1_USER` and `SECRET1_PASS`. The yaml for Pod `secret-handler` is available at `/opt/course/14/secret-handler.yaml`.

There is existing yaml for another Secret at `/opt/course/14/secret2.yaml`, create this Secret and mount it inside the same Pod at `/tmp/secret2`. Your changes should be saved under `/opt/course/14/secret-handler-new.yaml` on ckad9043. Both Secrets should only be available in Namespace `moon`.

---
<a id="question-11"></a>

## Question 11 – ConfigMap, Configmap-Volume

Solve this question on instance: `ssh ckad9043`

Team Moonpie has a nginx server Deployment called `web-moon` in Namespace `moon`. Someone started configuring it but it was never completed. To complete please create a ConfigMap called `configmap-web-moon-html` containing the content of file `/opt/course/15/web-moon.html` under the data key-name `index.html`.

The Deployment `web-moon` is already configured to work with this ConfigMap and serve its content. Test the nginx configuration for example using `curl` from a temporary `nginx:alpine` Pod.

---
<a id="question-12"></a>

## Question 12 – Logging sidecar

Solve this question on instance: `ssh ckad7326`

The Tech Lead of Mercury2D decided it's time for more logging, to finally fight all these missing data incidents. There is an existing container named `cleaner-con` in Deployment `cleaner` in Namespace `mercury`. This container mounts a volume and writes logs into a file called `cleaner.log`.

The yaml for the existing Deployment is available at `/opt/course/16/cleaner.yaml`. Persist your changes at `/opt/course/16/cleaner-new.yaml` on ckad7326 but also make sure the Deployment is running.

Create a sidecar container named `logger-con`, image `busybox:1.31.0` , which mounts the same volume and writes the content of `cleaner.log` to stdout, you can use the `tail -f` command for this. This way it can be picked up by `kubectl logs`.

Check if the logs of the new container reveal something about the missing data incidents.

---
<a id="question-13"></a>

## Question 13 – InitContainer

Solve this question on instance: `ssh ckad5601`

Last lunch you told your coworker from department Mars Inc how amazing InitContainers are. Now he would like to see one in action. There is a Deployment yaml at `/opt/course/17/test-init-container.yaml`. This Deployment spins up a single Pod of image `nginx:1.17.3-alpine` and serves files from a mounted volume, which is empty right now.

Create an InitContainer named `init-con` which also mounts that volume and creates a file `index.html` with content `check this out!` in the root of the mounted volume. For this test we ignore that it doesn't contain valid html.

The InitContainer should be using image `busybox:1.31.0`. Test your implementation for example using `curl` from a temporary `nginx:alpine` Pod.

---
<a id="question-14"></a>

## Question 14 – Service misconfiguration

Solve this question on instance: `ssh ckad5601`

There seems to be an issue in Namespace `mars` where the ClusterIP service `manager-api-svc` should make the Pods of Deployment `manager-api-deployment` available inside the cluster.

You can test this with `curl manager-api-svc.mars:4444` from a temporary `nginx:alpine` Pod. Check for the misconfiguration and apply a fix.

---
<a id="question-15"></a>

## Question 15 – Service ClusterIP->NodePort

Solve this question on instance: `ssh ckad5601`

In Namespace `jupiter` you'll find an apache Deployment (with one replica) named `jupiter-crew-deploy` and a ClusterIP Service called `jupiter-crew-svc` which exposes it. Change this service to a NodePort one to make it available on all nodes on port 30100.

Test the NodePort Service using the internal IP of all available nodes and the port 30100 using `curl`, you can reach the internal node IPs directly from your main terminal. On which nodes is the Service reachable? On which node is the Pod running?

---
<a id="question-16"></a>

## Question 16 – NetworkPolicy

Solve this question on instance: `ssh ckad7326`

In Namespace `venus` you'll find two Deployments named `api` and `frontend`. Both Deployments are exposed inside the cluster using Services. Create a NetworkPolicy named `np1` which restricts outgoing tcp connections from Deployment `frontend` and only allows those going to Deployment `api`. Make sure the NetworkPolicy still allows outgoing traffic on UDP/TCP ports 53 for DNS resolution.

Test using: `wget www.google.com` and `wget api:2222` from a Pod of Deployment frontend.

---
<a id="question-17"></a>

## Question 17 – Requests and Limits, ServiceAccount

Solve this question on instance: `ssh ckad7326`

Team Neptune needs 3 Pods of image `httpd:2.4-alpine`, create a Deployment named `neptune-10ab` for this. The containers should be named `neptune-pod-10ab`. Each container should have a memory request of 20Mi and a memory limit of 50Mi.

Team Neptune has its own ServiceAccount `neptune-sa-v2` under which the Pods should run. The Deployment should be in Namespace `neptune`.

---
<a id="question-18"></a>

## Question 18 – Labels, Annotations

Solve this question on instance: `ssh ckad9043`

Team Sunny needs to identify some of their Pods in namespace `sun`. They ask you to add a new label `protected: true` to all Pods with an existing label `type: worker` or `type: runner`. Also add an annotation protected: `do not delete this pod to all Pods` having the new label `protected: true`.

