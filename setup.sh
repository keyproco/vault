#!/bin/bash

CLUSTER_NAME="labspace"

kind create cluster --name "$CLUSTER_NAME"

if [[ $? -ne 0 ]]; then
  echo "Error: Failed to create the kind cluster named '$CLUSTER_NAME'."
  exit 1
else
  echo "Success: Kubernetes cluster '$CLUSTER_NAME' created successfully."
fi
