#!/bin/bash

# Exit the script immediately if any command returns a non-zero status
set -e

# Import common variables
. ./helper-scripts/variables.sh

# Start Minikube
printf "${GREEN}Starting Minikube ...\n${NC}"
sh "${SCRIPTS_DIR}"/start-minikube.sh

# Unset the Minikube environment variables
printf "${GREEN}\nUnsetting Minikube environment ...\n${NC}"
minikube docker-env --unset

# Build the microservices
sh "${SCRIPTS_DIR}/build-microservices.sh"

# Unset the Minikube environment variables again
printf "${GREEN}\nUnsetting Minikube environment ...\n${NC}"
minikube docker-env --unset

# Build the frontend application
sh "${SCRIPTS_DIR}/build-frontend.sh"