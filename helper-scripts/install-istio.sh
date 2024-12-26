#!/bin/bash

# Exit the script immediately if any command returns a non-zero status
set -e

# Import common variables
. ./helper-scripts/variables.sh

# Install Istio using the demo profile without any gateways
printf "${GREEN}\nConfiguring Istio ...\n${NC}"
istioctl install -f "$K8S_DIR"/istio-config/demo-profile-no-gateways.yaml -y

# Install the Gateway API Custom Resource Definitions (CRDs) if they are not already present
printf "${GREEN}\nInstalling Gateway API CRDs ...\n${NC}"
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.0/standard-install.yaml

# Display the installed Gateway API implementations
printf "${GREEN}\nInstalled Gateway API implementations:\n${NC}"
kubectl get gatewayclass