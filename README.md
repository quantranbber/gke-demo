# INSTRUCTIONS
## STEPS
### Overview contents
0. Preparation
1. terraform appy -> to create clusters, artifact repository, vpc, service accounts, etc..
2. kubectl apply -> to create resources in cluster: service, deployment, ingress, limit range, etc...
3. Rollout and set image
4. Cleanup

### SUMARY
#### This project use terraform and kubectl to manage GKE cluster.
#### You must install terraform binary, kubectl binary, gcloud CLI before start the installation guide

### Step 0: Preparation
1. Gcloud authen
```bash
gcloud auth login
...
gcloud components update
```

## INSTALLATION
### Step 1: Terraform
1. Run this command
```bash
cd terraform
terraform apply -auto-approve -var-file=variables.tfvars
```

After that, we will get the cluster ip as output

### Step 2: Kubectl
1. Run this command
```bash
gcloud auth activate-service-account --key-file=[SERVICE_ACCOUNT_TO_AUTH_GKE]
gcloud container clusters get-credentials [CLUSTER_NAME] --project=[PROJECT_ID] --zone=[ZONE] --dns-endpoint
kubectl create ns app
kubectl apply -f k8s/
```

2. Check k8s resources
```bash
kubectl describe po -n app
kubectl describe svc -n app
kubectl describe ingress -n app
```

## Rollout & update new image
```bash
IMAGE_NAME=$(gcloud secrets versions access latest --secret=[SECRET_IMAGE_NAME] --project=[PROJECT_ID])

kubectl set image deployment [DEPLOYMENT_NAME] my-app-container=[NEW_IMAGE] -n app
kubectl rollout status deployment [DEPLOYMENT_NAME] -n app 
```

## Cleanup
```bash
kubectl delete -f k8s/
cd terraform && terraform destroy -auto-approve -var-file=variables.tfvars
```

TODO: implement helm to store dynamic image


