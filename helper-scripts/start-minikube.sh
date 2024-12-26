#!/bin/bash

# Exit the script immediately if any command returns a non-zero status
set -e

# Import common variables
. ./helper-scripts/variables.sh

# Start Minikube if it is not already running
if ! (minikube status | grep -q "Running"); then
  minikube start --memory=12288 --cpus=10
else
  printf "Minikube is already running.\n"
fi