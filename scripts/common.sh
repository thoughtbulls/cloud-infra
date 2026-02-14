#!/bin/bash

set -e

ENV=$1
TARGET_LAYER=$2

if [ -z "$ENV" ]; then
  echo "Usage: ./script.sh <environment> [layer]"
  echo "Example: ./deploy.sh dev storage"
  exit 1
fi

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

TFVARS="$ROOT_DIR/envs/$ENV/terraform.tfvars"

NETWORK_BACKEND="$ROOT_DIR/envs/$ENV/network-backend.hcl"
IAM_BACKEND="$ROOT_DIR/envs/$ENV/iam-backend.hcl"
STORAGE_BACKEND="$ROOT_DIR/envs/$ENV/storage-backend.hcl"
WORKSPACE_BACKEND="$ROOT_DIR/envs/$ENV/databricks-backend.hcl"

##############################################
# Dependency Graph
##############################################

get_layers() {

  case "$TARGET_LAYER" in
    network)
      echo "network iam storage workspace"
      ;;
    iam)
      echo "iam storage workspace"
      ;;
    storage)
      echo "storage workspace"
      ;;
    workspace)
      echo "network iam storage workspace"
      ;;
    workspace-only)
      echo "workspace"
      ;;
    "" )
      echo "network iam storage workspace"
      ;;
    *)
      echo "Invalid layer: $TARGET_LAYER"
      exit 1
      ;;
  esac
}


##############################################
# Layer Runner
##############################################

run_layer () {

  LAYER_NAME=$1
  LAYER_PATH=$2
  BACKEND=$3
  ACTION=$4

  echo ""
  echo "========== $LAYER_NAME =========="

  cd "$ROOT_DIR/$LAYER_PATH"

  terraform init -backend-config="$BACKEND"

  if [ "$ACTION" == "plan" ]; then
    terraform plan -var-file="$TFVARS"

  elif [ "$ACTION" == "apply" ]; then
    terraform apply -auto-approve -var-file="$TFVARS"

  elif [ "$ACTION" == "destroy" ]; then
    terraform destroy -auto-approve -var-file="$TFVARS"
  fi

  cd "$ROOT_DIR"
}
