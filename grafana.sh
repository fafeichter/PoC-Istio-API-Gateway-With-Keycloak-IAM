#!/bin/bash

# Exit the script immediately if any command returns a non-zero status
set -e

# Import common variables
. ./helper-scripts/variables.sh

# Start Minikube
printf "${GREEN}Starting Minikube ...\n${NC}"
sh "${SCRIPTS_DIR}"/start-minikube.sh

# Install Istio using the specified installation script
sh "${SCRIPTS_DIR}/install-istio.sh"

# Install Grafana and other telemetry addons
printf "${GREEN}\nDeploying telemetry addons, including Grafana ...\n${NC}"
kubectl apply -f "$K8S_DIR/telemetry-addons"

# Wait for the Grafana deployment to be available
printf "${GREEN}\nWaiting for Grafana deployment to be ready ...\n${NC}"
kubectl rollout status deployment/grafana -n istio-system

# Access the Grafana dashboard
printf "${GREEN}\nAccessing Grafana dashboard ...\n${NC}"
kubectl port-forward svc/grafana 3000:3000 -n istio-system &
open "http://localhost:3000" &

# Required for terminating background processes with CTRL+C
wait