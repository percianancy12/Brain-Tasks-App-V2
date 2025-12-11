# Brain Tasks App - Deployment Guide

## 📋 Prerequisites
Ensure the following tools are installed and configured:
- AWS CLI with appropriate permissions
- Docker installed locally
- kubectl installed and configured
- eksctl installed
- Git installed

---

## 🚀 Steps

### 1. Clone the Repository
```bash
git clone https://github.com/Vennilavan12/Brain-Tasks-App.git
cd Brain-Tasks-App
```

### 2. Build Docker Image
Build the React app Docker image served by Nginx:
```bash
docker build -t brain-tasks-app-v2 .
```

### 3. Run Locally
Run the Docker container locally to verify:
```bash
docker run --rm -p 3000:3000 brain-tasks-app-v2
```
Access the app at: [http://localhost:3000](http://localhost:3000)

---

### 4. Push to Amazon ECR
**Create ECR repository:**
```bash
aws ecr create-repository --repository-name project1-v2-ecr-repo --region ap-south-1
```

**Authenticate Docker to ECR and tag image:**
```bash
aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 043206426566.dkr.ecr.ap-south-1.amazonaws.com

docker tag brain-tasks-app-v2:latest 043206426566.dkr.ecr.ap-south-1.amazonaws.com/project1-v2-ecr-repo:latest
```

**Push image:**
```bash
docker push 043206426566.dkr.ecr.ap-south-1.amazonaws.com/project1-v2-ecr-repo:latest
```

---

### 5. Deploy to Amazon EKS
**Create EKS cluster:**
```bash
eksctl create cluster --name project1-cluster --region ap-south-1 --nodes 2 --node-type t3.medium
```

**Update kubeconfig:**
```bash
aws eks update-kubeconfig --region ap-south-1 --name project1-cluster
```

---

### 6. CI/CD Pipeline
- The pipeline uses **AWS CodeBuild** and **CodePipeline** to automate build and deployment.
- `buildspec.yml` handles Docker build, tag, and push to ECR.
- CodePipeline triggers build and deploy steps.

---

### 7. IAM & Access
- Ensure CodePipeline/CodeBuild IAM roles have access to EKS.
- Modify `aws-auth` ConfigMap if needed to add roles with `system:masters` group.

---

### 8. Monitoring & Verification
Use **CloudWatch Logs** to monitor pipeline and build logs.

**Check deployment rollout status:**
```bash
kubectl rollout status deployment/brain-tasks-deploy
```

**Verify service:**
```bash
kubectl get svc brain-tasks-svc -o wide
```

---

## ✅ Outcome
- Application is deployed on **Amazon EKS** and accessible via **LoadBalancer**.
- Pipeline automates build and deployment.
- Logs and status visible in **AWS CloudWatch**.

---

## 📝 Additional Notes
- The app is served on **port 3000** via Nginx.
- Kubernetes service maps **port 80 → container port 3000**.
- `appspec.yaml` is not required unless using **CodeDeploy lifecycle hooks**.

