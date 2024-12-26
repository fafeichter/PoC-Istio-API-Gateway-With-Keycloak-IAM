#!/bin/bash

# Exit the script immediately if any command returns a non-zero status
set -e

# Import common variables
. ./helper-scripts/variables.sh

# Define the JWT for authorization
JWT="eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJoeE01MFdZcTltS3VaaEhncjRMYnhtMWw0UnJPSzBBUkd0UUFoSG5Qcm9vIn0.eyJleHAiOjIwNDUwMzI5OTYsImlhdCI6MTcyOTY3Mjk5NiwiYXV0aF90aW1lIjoxNzI5NjcyOTk2LCJqdGkiOiJhZjRhNzAxOS03NTcyLTRmNjgtYjVkZC00YTA0OTU5ZWJiZGYiLCJpc3MiOiJodHRwOi8vbG9jYWxob3N0OjgwODAvcmVhbG1zL2Vjb21tZXJjZSIsImF1ZCI6ImFjY291bnQiLCJzdWIiOiJmYmU3YjkxZS00YTZkLTQ0ZGItODdkNS1lM2U4NjZlMmE1MDkiLCJ0eXAiOiJCZWFyZXIiLCJhenAiOiJlY29tbWVyY2UiLCJzaWQiOiI3YmU1NWNmMC0xNjI1LTQzOGItYTNmYy1kMTY0YTEwODIzYzkiLCJhY3IiOiIxIiwiYWxsb3dlZC1vcmlnaW5zIjpbImh0dHBzOi8vb2F1dGgucHN0bW4uaW8iXSwicmVhbG1fYWNjZXNzIjp7InJvbGVzIjpbImRlZmF1bHQtcm9sZXMtZWNvbW1lcmNlIiwib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiJdfSwicmVzb3VyY2VfYWNjZXNzIjp7ImFjY291bnQiOnsicm9sZXMiOlsibWFuYWdlLWFjY291bnQiLCJtYW5hZ2UtYWNjb3VudC1saW5rcyIsInZpZXctcHJvZmlsZSJdfX0sInNjb3BlIjoicHJvZmlsZSBlbWFpbCIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJuYW1lIjoiRmFiaWFuIEZlaWNodGVyIiwicHJlZmVycmVkX3VzZXJuYW1lIjoiZmFiaWFuIiwiZ2l2ZW5fbmFtZSI6IkZhYmlhbiIsImZhbWlseV9uYW1lIjoiRmVpY2h0ZXIiLCJlbWFpbCI6ImZhYmlhbkBleGFtcGxlLmNvbSJ9.FMvMEPr0dd7Gc3fToj7ehoAp9nWH5DNQHlFC5lMzT_J4oCF2WvSwKj8YEELLWe7c-dLIjqEzkB9Y7G52DrjGUV1mxsoHbDvXZwaXcu07OjoAQ2J0wacGzXUjjwqJOpq9ipNXK08sXfYqKLLOAat6fvA1lPXuh2NnBqsFR16V_9jJ3bPB7y7ncnHtBYo-HUA5Rhw0VKsXMlYLCwYlu9s_n7z75xZOy4Hkf_XSqjrZ00dQ0zKaSDTiQjm666qqmaUiLXYBWUj-TuzUJlWFiYjftdcOcXu73sh-aMRGSthiLI4ZcJHBa9IyadcRdgSQ_SkPvAZufi4sEbL25kM67P0f8w"

# Prepare the Authorization header
AUTH_HEADER="Authorization: Bearer $JWT"

# Send requests to the customers API endpoint
while true
do
  # Generate random counts for each endpoint
  customer_count=$((RANDOM % 3 + 1))  # Random number between 1 and 3
  order_count=$((RANDOM % 3 + 1))     # Random number between 1 and 3

  # Run the first curl command customer_count times
  for _ in $(seq 1 $customer_count)
  do
    curl --location "http://localhost:4000/api/v1/customers/hello" --header "$AUTH_HEADER"
    echo
    sleep 0.1
  done

  # Run the second curl command order_count times
  for _ in $(seq 1 $order_count)
  do
    curl --location "http://localhost:4000/api/v1/orders/hello" --header "$AUTH_HEADER"
    echo
    sleep 0.1
  done
done
