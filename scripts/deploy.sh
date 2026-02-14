#!/bin/bash

source ./scripts/common.sh $1 $2

LAYERS=$(get_layers)

for layer in $LAYERS
do
  case $layer in
    network)
      run_layer "NETWORK" "infra/network" "$NETWORK_BACKEND" "apply"
      ;;
    iam)
      run_layer "IAM" "infra/iam" "$IAM_BACKEND" "apply"
      ;;
    storage)
      run_layer "STORAGE" "infra/storage" "$STORAGE_BACKEND" "apply"
      ;;
    workspace)
      run_layer "DATABRICKS WORKSPACE" "infra/databricks-workspace" "$WORKSPACE_BACKEND" "apply"
      ;;
  esac
done

echo ""
echo "========== DEPLOY COMPLETE =========="
