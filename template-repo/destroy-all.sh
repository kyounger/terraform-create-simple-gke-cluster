#!/usr/bin/env zsh

set -eo pipefail

exists=(tf-kubeconfig-*.yaml)
[[ ${#exists} -gt 1 ]] && echo "Too many matching kubeconfigs, exiting." && exit

export KUBECONFIG=$(pwd)/$exists

kubectl get nodes

# cd ./k8s-tf/
# terraform destroy -auto-approve

# cd ../cluster-tf
# terraform destroy -auto-approve
