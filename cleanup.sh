#!/bin/bash

# Exit the script immediately if any command returns a non-zero status
set -e

# Import common variables
. ./helper-scripts/variables.sh

ECOMMERCE_NAMESPACE="ecommerce"

# Delete all resources in the 'ecommerce' namespace and the namespace itself
printf "${GREEN}Deleting the whole '${ECOMMERCE_NAMESPACE}' namespace ...\n${NC}"
# Check if the namespace exists
if kubectl get namespace "$ECOMMERCE_NAMESPACE" >/dev/null 2>&1; then
  # Delete the namespace
  kubectl delete namespace "$ECOMMERCE_NAMESPACE"
else
  printf "${GREEN}\nAlready deleted.\n${NC}"
fi