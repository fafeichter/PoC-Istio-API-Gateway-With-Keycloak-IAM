#!/bin/bash

# Exit the script immediately if any command returns a non-zero status
set -e

# Import common variables
. ./helper-scripts/variables.sh

# Build the Docker images for microservices
printf "${GREEN}\nBuilding Docker images for microservices ...\n${NC}"
"${MICROSERVICES_DIR}"/gradlew -p "${MICROSERVICES_DIR}" bootBuildImage

# Load the built images into Minikube
printf "${GREEN}\nLoading Docker images into Minikube ...\n${NC}"
eval "$(minikube docker-env)"
minikube image load orders:0.0.1-SNAPSHOT customers:0.0.1-SNAPSHOT