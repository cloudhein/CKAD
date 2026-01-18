# CKAD Practice Questions 

---

## Table of Contents

- [Question 1 – Create Secret from Hardcoded Variables](#question-1)
- [Question 2 – Create CronJob with Schedule and History Limits](#question-2)
- [Question 3 – Create ServiceAccount, Role, and RoleBinding from Logs Error](#question-3)
- [Question 4 – Fix Broken Pod with Correct ServiceAccount](#question-4)
- [Question 5 – Build Container Image with Podman and Save as Tarball](#question-5)
- [Question 6 – Create Canary Deployment with Manual Traffic Split](#question-6)
- [Question 7 – Fix NetworkPolicy by Updating Pod Labels](#question-7)
- [Question 8 – Fix Broken Deployment YAML](#question-8)
- [Question 9 – Perform Rolling Update and Rollback](#question-9)
- [Question 10 – Add Readiness Probe to Deployment](#question-10)
- [Question 11 – Configure Pod and Container Security Context](#question-11)
- [Question 12 – Fix Service Selector](#question-12)
- [Question 13 – Create NodePort Service](#question-13)
- [Question 14 – Create Ingress Resource](#question-14)
- [Question 15 – Fix Ingress PathType](#question-15)
- [Question 16 – Add Resource Requests and Limits to Pod](#question-16)

---

<a id="question-1"></a>
## Question 1 – Create Secret from Hardcoded Variables

In namespace `default`, Deployment `api-server` exists with hard-coded environment variables:
- `DB_USER=admin`
- `DB_PASS=Secret123!`

Your task:
1. Create a Secret named `db-credentials` in namespace `default` containing these credentials
2. Update Deployment `api-server` to use the Secret via `valueFrom.secretKeyRef`
3. Do not change the Deployment name or namespace

### Solution

**Step 1 – Create the Secret**

```bash
kubectl create secret generic db-credentials \
  --from-literal=DB_USER=admin \
  --from-literal=DB_PASS=Secret123! \
  -n default
```

**Step 2 – Update Deployment to use Secret**

```bash
kubectl edit deploy api-server -n default
```

Replace the hardcoded environment variables:

```yaml
env:
  - name: DB_USER
    valueFrom:
      secretKeyRef:
        name: db-credentials
        key: DB_USER
  - name: DB_PASS
    valueFrom:
      secretKeyRef:
        name: db-credentials
        key: DB_PASS
```

Save and exit. Verify the rollout:

```bash
kubectl rollout status deploy api-server -n default
```

**Docs**

- Secrets: https://kubernetes.io/docs/concepts/configuration/secret/

---

## Question 2 – Create CronJob with Schedule and History Limits

<a id="question-2"></a>

- The DevOps team requires a recurring backup task for the legacy database in the default namespace. Create a CronJob named backup-job that meets the following requirements:

- Schedule: The job must run exactly twice an hour (every 30 minutes).

- Image: Use the busybox:latest image.

- Task: The container should print "Backup completed" to the standard output.

- Retention Policy: To save etcd storage, the system should automatically delete old job records. Ensure that only the last 3 successful executions and the last 2 failed executions are kept in history.

- Timeouts: If the job gets stuck, it must be automatically terminated after 5 minutes (300 seconds).

- Restart Policy: If the pod fails, Kubernetes should not attempt to restart the container.

**Tip:** Use `kubectl explain cronjob.spec` to find the correct field names.

### Solution

```bash
kubectl apply -f - <<EOF
apiVersion: batch/v1
kind: CronJob
metadata:
  name: backup-job
  namespace: default
spec:
  schedule: "*/30 * * * *"
  successfulJobsHistoryLimit: 3
  failedJobsHistoryLimit: 2
  jobTemplate:
    spec:
      activeDeadlineSeconds: 300
      template:
        spec:
          restartPolicy: Never
          containers:
            - name: backup
              image: busybox:latest
              command: ["/bin/sh", "-c"]
              args: ["echo Backup completed"]
EOF
```

Verify the CronJob:

```bash
kubectl get cronjob backup-job
kubectl describe cronjob backup-job
```

To test immediately, create a Job from the CronJob:

```bash
kubectl create job backup-job-test --from=cronjob/backup-job
kubectl logs job/backup-job-test
```

**Docs**

- CronJobs: https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/

---

<a id="question-3"></a>
## Question 3 – Create ServiceAccount, Role, and RoleBinding from Logs Error

- The Pod log-collector in the namespace audit is failing to start. It is supposed to monitor other Pods in the namespace, but it is crashing due to access denial.

Requirements:

- Diagnose: Inspect the Pod logs to determine exactly what operation is being denied.

- Configure RBAC: Create a new ServiceAccount named log-sa in the audit namespace. Configure the necessary Role and RoleBinding (named log-role and log-rb) to grant only the permissions identified in your diagnosis.

- Fix the Pod: Update the log-collector Pod to use this new identity. (Note: You may need to recreate the Pod).

### Solution

**Step 1 – Create ServiceAccount**

```bash
kubectl create sa log-sa -n audit
```

**Step 2 – Create Role**

```bash
kubectl apply -f - <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: log-role
  namespace: audit
rules:
  - apiGroups: [""]
    resources: ["pods"]
    verbs: ["get", "list", "watch"]
EOF
```

**Step 3 – Create RoleBinding**

```bash
kubectl create rolebinding log-rb \
  --role=log-role \
  --serviceaccount=audit:log-sa \
  -n audit
```

**Step 4 – Update Pod to use ServiceAccount**

Since Pods have immutable `serviceAccountName`, delete and recreate:

```bash
kubectl get pod log-collector -n audit -o yaml > /tmp/log-collector.yaml
```

Edit the file to change:
- `spec.serviceAccountName: log-sa`
- Remove `spec.serviceAccount` if present

Then:

```bash
kubectl delete pod log-collector -n audit
kubectl apply -f /tmp/log-collector.yaml
```

Or use patch if the Pod allows it (may fail due to immutability):

```bash
kubectl patch pod log-collector -n audit \
  -p '{"spec":{"serviceAccountName":"log-sa"}}'
```

If patch fails, delete and recreate.

**Docs**

- RBAC: https://kubernetes.io/docs/reference/access-authn-authz/rbac/

---

<a id="question-4"></a>
## Question 4 – Fix Broken Pod with Correct ServiceAccount

The Pod metrics-pod in the monitoring namespace is currently failing to scrape cluster data. The application logs indicate "403 Forbidden" errors when trying to access nodes and pods.

Task:

1. Investigate the existing RBAC configuration in the monitoring namespace.

2. Identify the existing ServiceAccount that holds the privileges to get and list both Pods and Nodes.

3. Reconfigure the metrics-pod to use this correct ServiceAccount. (Note: The Pod must remain running and be named metrics-pod.)

**Docs**

- ServiceAccounts: https://kubernetes.io/docs/concepts/security/service-accounts/

---

<a id="question-5"></a>
## Question 5 – Build Container Image with Podman and Save as Tarball

On the node, directory `/root/app-source` contains a valid `Dockerfile`.

Your task:
1. Build a container image using Podman with name `my-app:1.0` using `/root/app-source` as build context
2. Save the image as a tarball to `/root/my-app.tar`

**Note:** The exam environment uses Podman, not Docker. Use `podman` commands.

**Docs**

- Podman: https://docs.podman.io/

---

<a id="question-6"></a>
## Question 6 – Create Canary Deployment with Manual Traffic Split

- The webapp application in the production namespace is currently running v1 (image: nginx:1.14). You need to perform a controlled Canary release of v2 (image: nginx:1.16) using native Kubernetes load balancing.

- Task: Reconfigure the application to meet the following traffic distribution requirements:

- Total Capacity: The application must run on exactly 10 pods in total (combined count of v1 and v2).

- Traffic Split: Configure the deployments so that 80% of traffic goes to v1 and 20% of traffic goes to v2.

- Routing: Ensure the existing Service webapp-svc automatically routes traffic to all 10 pods.

**Note:** Do not use Ingress, Service Mesh, or external load balancers.

**Docs**

- Deployments: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/

---

<a id="question-7"></a>
## Question 7 – Fix NetworkPolicy by Updating Pod Labels

The 3-tier application in the namespace network-demo is currently experiencing connectivity issues. The Security Team has applied strict NetworkPolicies to enforce traffic flow, but the application Pods do not seem to match the security requirements.

**Constraints:**

- You are STRICTLY FORBIDDEN from editing, deleting, or creating NetworkPolicies.

- You must fix the issue solely by modifying the Pods.

**Task:**

- Inspect the existing NetworkPolicies to identify the specific labels required for allowed traffic.

- Update the labels on the frontend, backend, and database Pods to match the policy requirements.

- Ensure the application flows as follows:

- `frontend` can access backend (TCP 80).

- `backend` can access database (TCP 5432).

**Time Saver Tip:** Use `kubectl label` instead of editing YAML and recreating Pods.

**Docs**

- NetworkPolicy: https://kubernetes.io/docs/concepts/services-networking/network-policy/

---

<a id="question-8"></a>
## Question 8 – Fix Broken Deployment YAML

A manifest file located at /root/broken-deploy.yaml was prepared to deploy a legacy application, but it is failing to create resources on the current cluster version.

**Task:**

- Attempt to apply the manifest to identify the issues.

- Edit the file /root/broken-deploy.yaml to fix the configuration errors so that it is compatible with the current Kubernetes API.

- Ensure the Deployment is named broken-app, has 2 replicas, and is successfully Running.

**Docs**

- Deployments: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/

---

<a id="question-9"></a>
## Question 9 – Perform Rolling Update and Rollback

A Deployment named app-v1 is running in the default namespace using the image nginx:1.20. You are tasked with upgrading the application, but you must be prepared to revert changes immediately if issues arise.

**Task:**

1. **Update:** Perform a rolling update of the deployment `app-v1` to use the image `nginx:1.25.`

2. **Verify:** Wait for the rollout to complete and confirm the new Pods are running.

3. **Rollback:** Upon further inspection, a bug was identified in the new version. Immediately rollback the deployment to the previous revision.

4. **Confirm:** Ensure the deployment is running `nginx:1.20` again.

**Docs**

- Rolling Updates: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment

---

<a id="question-10"></a>
## Question 10 – Add Readiness Probe to Deployment

The Deployment named api-deploy in the default namespace is currently experiencing downtime during updates because Pods are receiving traffic before the application is fully initialized.

**Task:** Update the api-deploy Deployment to prevent traffic from being routed to Pods until they are confirmed ready. Configure a Readiness Probe for the container using the following requirements:

1. Check Mechanism: Perform an HTTP GET request on the path /ready at port 8080.

2. Timing: Wait 5 seconds before the first check (initialDelaySeconds), and perform the check every 10 seconds (periodSeconds) thereafter.

3. Outcome: Ensure the update is applied and the Deployment successfully rolls out.

**Docs**

- Readiness Probes: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/

---

<a id="question-11"></a>
## Question 11 – Configure Pod and Container Security Context

The Deployment named secure-app in the default namespace is currently running with default privileges. The security team has mandated a hardening policy for this application.

**Task:** Update the secure-app Deployment to meet the following security requirements:

1. **User Identity:** All processes in the Pod must run with User ID (UID) 1000 to prevent root access.

2. **Capabilities:** The container named `app` requires the ability to modify network interfaces. specificially add the `NET_ADMIN` capability to this container.

3. **Stability:** Ensure the rollout completes and the Pods are successfully running with the new configuration.

**Note:** Capabilities are set at the container level, not the Pod level.

**Docs**

- Security Context: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/

---

<a id="question-12"></a>
## Question 12 – Fix Service Selector

Users are reporting that they cannot access the internal application web-app via its Service web-svc in the default namespace. Initial troubleshooting reveals that the Service has no Endpoints.

**Task:**

1. Investigate the configuration of the Deployment `web-app` and the Service `web-svc.`

2. Identify the misconfiguration preventing the Service from discovering the Pods.

3. Fix the issue so that `web-svc` successfully routes traffic to the `web-app` Pods.

**Docs**

- Services: https://kubernetes.io/docs/concepts/services-networking/service/

---

<a id="question-13"></a>
## Question 13 – Create NodePort Service

The internal application `api-server` (Deployment) in the `default` namespace is currently running on container port 9090. External monitoring tools outside the cluster need to access this API.

Task: Expose the `api-server` application to the outside world by creating a Service named `api-nodeport.` The Service must meet the following criteria:

**Exposure:** The Service must be accessible on each Node's IP address.

**Port Mapping:** External requests arriving at the Service on port 80 must be routed to the container port 9090.

**Selector:** Ensure the Service correctly targets the existing Pods labeled `app=api.`

**Docs**

- NodePort Services: https://kubernetes.io/docs/concepts/services-networking/service/#nodeport

---

<a id="question-14"></a>
## Question 14 – Create Ingress Resource

The internal web application `web-deploy` is exposed internally via the Service `web-svc` on port 8080 in the `default` namespace. You need to make this application accessible to external users via a specific domain name.

Task: Create an Ingress resource named `web-ingress` in the default namespace with the following routing rules:

1. Host: The Ingress must only accept traffic for the domain `web.example.com.`

2. Path: All traffic to the root path `/` (Prefix match) must be routed to the backend.

3. Backend: Traffic should be forwarded to the Service `web-svc` on port 8080.

4. Ingress Class: Use the default Ingress Class (e.g., `nginx` or simply do not specify if the cluster has a default). Note: In the exam, usually `ingressClassName: nginx` is safe to add.

**Docs**

- Ingress: https://kubernetes.io/docs/concepts/services-networking/ingress/

---

<a id="question-15"></a>
## Question 15 – Fix Ingress PathType

You need to deploy a new Ingress resource for the API team. A manifest file has been provided at `/root/fix-ingress.yaml.` However, when you attempt to create the resource, the Kubernetes API Server rejects the request with a validation error.

Task:

1. Attempt to apply the manifest `/root/fix-ingress.yaml` to identify the syntax error.

2. Edit the file to fix the invalid field value.

3. Ensure the Ingress meets these requirements:

    - Path: `/api`

    - Path Match: Prefix matching

    - Backend: Service `api-svc` on port `8080`

4. Successfully create the Ingress resource.

**Docs**

- Ingress Path Types: https://kubernetes.io/docs/concepts/services-networking/ingress/#path-types

---

<a id="question-16"></a>
## Question 16 – Add Resource Requests and Limits to Pod

The `prod` namespace has strict resource governance policies enforced by a ResourceQuota. You need to deploy a new application Pod, but it must adhere to specific capacity rules relative to the namespace's total allowance.

Task:

1. Inspect the existing ResourceQuota in the `prod` namespace to identify the hard limits for CPU and Memory.

2. Create a new Pod named `resource-pod` in the `prod` namespace using the image `nginx:latest.`

3. Configure the Pod's resource usage as follows:

    - Limits: Set the CPU and Memory limits to exactly 50% (half) of the namespace's total hard limits found in step 1.

    - Requests: Set the CPU request to 100m and Memory request to 128Mi.

**Docs**

- ResourceQuota: https://kubernetes.io/docs/concepts/policy/resource-quotas/
- Resource Management: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/

---

## Summary

This practice exam covers the core CKAD topics you'll encounter:

- **Secrets and ConfigMaps** - Externalizing configuration
- **CronJobs** - Scheduled jobs with history limits
- **RBAC** - ServiceAccounts, Roles, RoleBindings
- **Container Images** - Building and managing images
- **Deployments** - Updates, rollbacks, probes, security contexts
- **Services** - ClusterIP, NodePort, selectors
- **Ingress** - Routing external traffic
- **Network Policies** - Controlling traffic flow

**Key Tips for the Exam:**
- Use `kubectl explain <resource>.<field>` extensively
- Check pod logs for error hints
- Use `kubectl label` for quick label fixes
- Export YAML, edit, and reapply for complex changes
- Verify changes with `kubectl get`, `kubectl describe`, and `kubectl logs`
- Practice time management - flag difficult questions and move on

Good luck with your CKAD exam!

