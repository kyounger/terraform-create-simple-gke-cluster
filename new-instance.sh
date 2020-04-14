#!/usr/bin/env zsh

set -eo pipefail

MOST_RECENT_NUM=`ls -d repo-* | cut -d "-" -f2 | sort | tail -1` && (( CLUSTER_NUM=$MOST_RECENT_NUM+1 ))
export CLUSTER_NUM

cp -r ./template-repo repo-$CLUSTER_NUM
ROOTDIR=`pwd`
REPODIR="$ROOTDIR/repo-$CLUSTER_NUM"
cd $REPODIR

REPO_CLUSTER_DIR="$REPODIR/cluster-tf"
cd $REPO_CLUSTER_DIR
echo "cluster_number=$CLUSTER_NUM" > cluster-number.auto.tfvars
terraform init
terraform plan -out myplan
terraform apply myplan

REPO_K8S_DIR="$REPODIR/k8s-tf"
cd $REPO_K8S_DIR
echo "cluster_number=$CLUSTER_NUM" > cluster-number.auto.tfvars
terraform init
terraform plan -out myplan
terraform apply myplan

REPO_HELMFILE_DIR="$REPODIR/helmfile"
cd $REPO_HELMFILE_DIR
./autoconfigure.sh
export KUBECONFIG=$REPODIR/tf-kubeconfig-kyounger$CLUSTER_NUM.yaml
./kubernetes_get_service_account_kubeconfig.sh hf-installer hf-installer
export KUBECONFIG=$(pwd)/kubeconfig-hf-installer.yaml
helmfile apply

