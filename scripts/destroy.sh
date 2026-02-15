#!/bin/bash

source ./scripts/common.sh $1 $2

LAYERS=$(get_layers)

for layer in $(echo $LAYERS | awk '{for(i=NF;i>0;i--) printf "%s ", $i}')
do
  case $layer in
    workspace)
      run_layer "DATABRICKS WORKSPACE" "infra/databricks-workspace" "$WORKSPACE_BACKEND" "destroy"
      ;;
    iam)
      run_layer "IAM" "infra/iam" "$IAM_BACKEND" "destroy"
      ;;
    storage)
      run_layer "STORAGE" "infra/storage" "$STORAGE_BACKEND" "destroy"
      ;;
    network)
      run_layer "NETWORK" "infra/network" "$NETWORK_BACKEND" "destroy"
      ;;
  esac
done

echo ""
echo "========== DESTROY COMPLETE =========="
