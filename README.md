# CKAD 2026 Exam Questions - Complete Study Guide

> **Certified Kubernetes Application Developer (CKAD) Practice Questions** 
> Comprehensive collection of realistic exam scenarios covering all CKAD domains

### Exam Domains Coverage
- **Application Design and Build**: 20%
- **Application Deployment**: 20%
- **Application Observability and Maintenance**: 15%
- **Application Environment, Configuration and Security**: 20%
- **Services and Networking**: 20%

---

## Practice Questions

### **Question 1: Docker File** (Application Design and Build)

A Dockerfile has been prepared at ~/home/Dockerfile.

1. Build an Image: Using the prepared Dockerfile, build a container image with the name **devmaq** and Tag **3.0**.

   - You may use the tool of your choice: **docker, scopio, podman, or img**.

   - Constraint: Please don't push the build image to a registry, run a container, or otherwise consume it.

2. Export the Image: Using the tool of your choice, export the built container image in OCI-format and store it at **~/human-stork/devmac-3.0.tar**.

### **Question 2: Security Context** (Application Environment, Configuration and Security)

Modify the existing Deployment named hotfix-deployment running in namespace quetzal so that its containers:

1. Run with user ID 30000.

2. Privilege escalation is forbidden.

The hotfix-deployment manifest file can be found at: ~/broker-deployment/hotfix-deployment.yaml.

### **Question 3: K8s Secret** (Application Environment, Configuration and Security)

You are tasked with deploying a pod that uses sensitive credentials stored in a Kubernetes Secret.

1. Create a Secret named **db-credentials** in the default namespace with the following key-value pairs: ***username: admin and password: P@ssw0rd123***

2. Create a Pod named **env-secret-pod** that runs a single container using the image **busybox**, and keeps running **(sleep 3600)**.

3. The container should expose the Secret values as environment variables:
   - Environment variable **DB_USER** should use the value from username
   - Environment variable **DB_PASS** should use the value from password

4. Verify the environment variables are correctly set inside the pod.

### **Question 4: K8s RBAC** (Application Environment, Configuration and Security)

A pod within the Deployment named **dev-deployment** and in **namespace meta** is logging errors.

1. Look at the logs and identify error messages. Find errors, including: User **"system:serviceaccount:meta:default"** cannot list resource **"deployment" [...] in the namespace meta.**

2. Update the Deployment **dev-deployment** to resolve the errors in the logs of the Pod.

The dev-deployment's manifest can be found at: ~/dev-deployment.yaml.

### **Question 5: Scale Deployment & Service Creation** (Services and Networking)

You need to scale an existing deployment for availability and create a service to expose the deployment within your infrastructure.

Task:

1. Modify Deployment: Start with the deployment named nov2025-deployment in namespace nov2025.

   - Add the label func=webFrontEnd to the pod template metadata to identify the pod for the service definition.

   - Scale the deployment to 4 replicas.

2. Create Service: Create and deploy a service in namespace nov2025 that:

   - Is named berry (Note: Use lowercase berry as K8s resource names must be lowercase).

   - Is of type NodePort.

   - Exposes the service on TCP port 8080.

   - Is mapped to the pods defined by the specification of nov2025-deployment.

### **Question 6: Rolling Updates** (Application Deployment)

Please complete the following:

1. Update Strategy: Update the app deployment in the nov2025 namespace with a maxSurge of 5% and a maxUnavailable of 2%.

2. Rolling Update: Perform a rolling update of the web1 deployment, changing the image version to 1.13 (The question mentions repo/nginx, but for local practice, we will use standard nginx).

3. Rollback: Rollback the app deployment to the previous version.

### **Question 7: CronJob** (Application Design and Build)

Create a CronJob in the production namespace that meets the following criteria:

1. Image/Command: Runs a busybox container executing the command date.

2. Schedule: The CronJob runs every 30 minutes.

3. Job Specifications: The created Job must have:

   - 2 completions (successful runs required to mark the Job as complete).

   - 3 retries on failure.

   - Terminate if running longer than 30 seconds.

4. Naming:

   - CronJob name: log-cleaner

   - Container name: log

5. Verify: The execution of the CronJob.

### **Question 8: Pod and Expose Pod** (Application Design and Build)

A web application requires a specific version of redis to be used as a cache.

Create a Pod named cache.

The Pod must run in the web namespace.

Use the image lfccncf/redis with the tag 3.2.

Expose port 6379.

Leave the Pod running when complete.

### **Question 9: Utilize container logs** (Application Observability and Maintenance)

Task 1:

- Deploy the winter pod to the cluster using the provided yaml spec file at /opt/ckadnov2025/winter.yaml.

- Retrieve all currently available application logs from the running pod and store them in the file /opt/ckadnov2025/log_Output.txt, which has already been created.

Task 2:

- From the pods running in namespace cpu-stress, write the name only of the pod that is consuming the most CPU to file /opt/ckadnov2025/pod.txt.

### **Question 10: API Deprecations** (Application Observability and Maintenance)

A team tries to apply the hpa manifest, which was originally created on an older cluster located in ~/ckad-hpa.yaml.

Task:

- Identify the correct API version that should be used.

- Update the manifest to work on Kubernetes v1.32.

- Verify that the HPA is created successfully.

### **Question 11: Canary Deployment** (Application Deployment)

An application named webapp has two versions in namespace `production`, an `v1` and `v2`. Both versions must be accessible over Service named `webapp-svc`

- Approximately `80%` of traffic should be routed to `v1` .
- Approximately `20%` of traffic should be routed to `v2`.
- Use only Kubernetes native objects.
- Do not use Ingress, Service Mesh, or external load balancers Configure the required Kubernetes resources to satisfy the above requirements.

