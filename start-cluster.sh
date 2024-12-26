#!/bin/bash

# Exit the script immediately if any command returns a non-zero status
set -e

# Import common variables
. ./helper-scripts/variables.sh

# Start Minikube
printf "${GREEN}Starting Minikube ...\n${NC}"
sh "${SCRIPTS_DIR}"/start-minikube.sh

# Install Istio
printf "${GREEN}\nInstalling Istio ...\n${NC}"
sh "${SCRIPTS_DIR}"/install-istio.sh

# Create a new Kubernetes namespace for the application
printf "${GREEN}\nCreating Kubernetes namespace 'ecommerce' ...\n${NC}"
kubectl apply -f "$K8S_DIR"/manifests/001_namespace.yaml

# Switch the current context to the newly created namespace
printf "${GREEN}\nSwitching context to namespace 'ecommerce' ...\n${NC}"
kubectl config set-context --current --namespace=ecommerce

# Enable automatic injection of Envoy sidecar proxies for the namespace
printf "${GREEN}\nEnabling Istio sidecar injection for 'ecommerce' namespace ...\n${NC}"
kubectl label namespace ecommerce istio-injection=enabled --overwrite

# Mount the Keycloak realm import file to the Minikube virtual machine
printf "${GREEN}\nMounting Keycloak realm import file to Minikube virtual machine ...\n${NC}"
minikube cp ecommerce/k8s/keycloak-import-data/ecommerce-realm.json /mnt/data/ecommerce-realm.json

# Deploy the initial set of components in the cluster
printf "${GREEN}\nDeploying initial components in the cluster ...\n${NC}"
kubectl apply -f "$K8S_DIR"/manifests/002_customer-microservice.yaml
kubectl apply -f "$K8S_DIR"/manifests/003_order-microservice.yaml
kubectl apply -f "$K8S_DIR"/manifests/004_keycloak-postgres.yaml
kubectl apply -f "$K8S_DIR"/manifests/005_keycloak.yaml
kubectl apply -f "$K8S_DIR"/manifests/006_angular-spa.yaml

# Wait for the Keycloak deployment to become available
printf "${GREEN}\nWaiting for Keycloak deployment to become available ...\n${NC}"
kubectl rollout status deployment/keycloak-deployment -n ecommerce --timeout=600s

# Introduce a brief pause to ensure Keycloak is fully operational
printf "${GREEN}\nBrief pause to ensure Keycloak is fully operational ...\n${NC}"
sleep 5

# Deploy the remaining components in the cluster
printf "${GREEN}\nDeploying remaining components in the cluster ...\n${NC}"
kubectl apply -f "$K8S_DIR"/manifests/007_api-gateway.yaml
kubectl apply -f "$K8S_DIR"/manifests/008_oauth.yaml

# Change the service type of the gateway to ClusterIP by annotating the gateway
printf "${GREEN}\nChanging service type of the gateway to ClusterIP ...\n${NC}"
kubectl annotate gateway ecommerce-gateway networking.istio.io/service-type=ClusterIP

# Print information about the current state of the cluster
printf "${GREEN}\nNamespaces:\n${NC}"
kubectl get namespace -L istio-injection
printf "${GREEN}\nGateways:\n${NC}"
kubectl get gateway
printf "${GREEN}\nDeployments:\n${NC}"
kubectl get deployments
printf "${GREEN}\nServices:\n${NC}"
kubectl get services
printf "${GREEN}\nPods:\n${NC}"
kubectl get pods

# Wait for the API gateway deployment to become available
printf "${GREEN}\nWaiting for API gateway deployment to become available ...\n${NC}"
kubectl rollout status deployment/ecommerce-gateway-istio -n ecommerce --timeout=60s

# Wait for the Angular frontend deployment to become available
printf "${GREEN}\nWaiting for Angular frontend deployment to become available ...\n${NC}"
kubectl rollout status deployment/angular-spa-deployment -n ecommerce --timeout=60s

# Set up port forwarding to access the API gateway and Keycloak
printf "${GREEN}\nSetting up port forwarding for API gateway and Keycloak ...\n${NC}"
kubectl port-forward svc/ecommerce-gateway-istio 4000:4000 &
kubectl port-forward svc/keycloak 8080:8080 &
open "http://localhost:4000" &

# Required for terminating background processes with CTRL+C
wait