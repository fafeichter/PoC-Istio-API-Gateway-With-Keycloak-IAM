#!/bin/bash

# Exit the script immediately if any command returns a non-zero status
set -e

# Import common variables
. ./helper-scripts/variables.sh

# Define Keycloak configuration
KEYCLOAK_URL="http://localhost:8080"
KEYCLOAK_REALM="ecommerce"
CLIENT_ID="ecommerce"
USERNAME="fabian"
PASSWORD="fabian"

# Make a cURL request to retrieve the access token
response=$(curl -s -X POST "$KEYCLOAK_URL/realms/$KEYCLOAK_REALM/protocol/openid-connect/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=password" \
  -d "client_id=$CLIENT_ID" \
  -d "username=$USERNAME" \
  -d "password=$PASSWORD")

# Extract the access token using jq
access_token=$(echo "$response" | jq -r .access_token)

# Check if the access token was successfully retrieved
if [ -z "$access_token" ]; then
  printf "${GREEN}\nError: Access token could not be retrieved.\n${NC}"
  printf "${GREEN}\nResponse: $response\n${NC}"
  exit 1
fi

# Output the retrieved access token
echo  $access_token