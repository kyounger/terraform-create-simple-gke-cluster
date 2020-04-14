#!/usr/bin/env zsh

set -eo pipefail

MOST_RECENT_NUM=`ls -d repo-* | cut -d "-" -f2 | sort | tail -1` && (( CLUSTER_NUM=$MOST_RECENT_NUM+1 ))
export CLUSTER_NUM

# Copy the template repo
cp -r ./template-repo repo-$CLUSTER_NUM
ROOTDIR=`pwd`
REPODIR="$ROOTDIR/repo-$CLUSTER_NUM"
cd $REPODIR
git init; git add .; git commit -m "init"

# Run the gke cluster creation tf. This generates a kubeconfig specifically for this cluster and puts it in the REPODIR
REPO_CLUSTER_DIR="$REPODIR/cluster-tf"
cd $REPO_CLUSTER_DIR
echo "cluster_number=$CLUSTER_NUM" > cluster-number.auto.tfvars
terraform init
terraform plan -out myplan
terraform apply myplan

# Use the kubeconfig generated the k8s tf
export KUBECONFIG=$REPODIR/tf-kubeconfig-kyounger$CLUSTER_NUM.yaml

# Run the kubernetes tf
REPO_K8S_DIR="$REPODIR/k8s-tf"
cd $REPO_K8S_DIR
echo "cluster_number=$CLUSTER_NUM" > cluster-number.auto.tfvars
terraform init
terraform plan -out myplan
terraform apply myplan


REPO_HELMFILE_DIR="$REPODIR/helmfile"
cd $REPO_HELMFILE_DIR
./autoconfigure.sh
# Generate a kubeconfig specifically with creds for the helmfile installer sa
$ROOTDIR/kubernetes_get_service_account_kubeconfig.sh hf-installer hf-installer $REPO_HELMFILE_DIR
# # use that KUBECONFIG as the context for running helmfile
# export KUBECONFIG=$REPO_HELMFILE_DIR/kubeconfig-hf-installer.yaml
# helmfile apply # todo: replace with docker run of helmfile image


