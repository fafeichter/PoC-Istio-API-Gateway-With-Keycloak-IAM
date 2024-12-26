#!/bin/bash

# Exit the script immediately if any command returns a non-zero status
set -e

# Import common variables
. ./helper-scripts/variables.sh

# Build the Docker images for the Angular frontend
printf "${GREEN}\nBuilding Docker image for Angular ...\n${NC}"
docker build -t angular:0.0.1-SNAPSHOT "${FRONTEND_DIR}"

# Load the built image into Minikube
printf "${GREEN}\nLoading Docker image into Minikube ...\n${NC}"
eval "$(minikube docker-env)"
minikube image load angular:0.0.1-SNAPSHOT