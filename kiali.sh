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

# Install Kiali and other telemetry addons
printf "${GREEN}\nDeploying telemetry addons, including Kiali ...\n${NC}"
kubectl apply -f "$K8S_DIR/telemetry-addons"

# Wait for the Kiali deployment to be available
printf "${GREEN}\nWaiting for Kiali deployment to be ready ...\n${NC}"
kubectl rollout status deployment/kiali -n istio-system

# Access the Kiali dashboard
printf "${GREEN}\nAccessing Kiali dashboard ...\n${NC}"
istioctl dashboard kiali &
open "http://localhost:20001" &

# Required for terminating background processes with CTRL+C
wait