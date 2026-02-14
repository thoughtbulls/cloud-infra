#!/bin/bash

source ./scripts/common.sh $1 $2

LAYERS=$(get_layers)

for layer in $LAYERS
do
  case $layer in
    network)
      run_layer "NETWORK" "infra/network" "$NETWORK_BACKEND" "plan"
      ;;
    iam)
      run_layer "IAM" "infra/iam" "$IAM_BACKEND" "plan"
      ;;
    storage)
      run_layer "STORAGE" "infra/storage" "$STORAGE_BACKEND" "plan"
      ;;
    workspace)
      run_layer "DATABRICKS WORKSPACE" "infra/databricks-workspace" "$WORKSPACE_BACKEND" "plan"
      ;;
  esac
done

echo ""
echo "========== PLAN COMPLETE =========="
