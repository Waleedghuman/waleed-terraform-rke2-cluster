#!/bin/bash

# install kubectl
sudo snap install kubectl --classic
sudo snap install helm --classic

# configure kubectl
mkdir -p /home/ubuntu/.kube
sudo cp /etc/rancher/rke2/rke2.yaml /home/ubuntu/.kube/config
sudo chmod 644 /home/ubuntu/.kube/config

export KUBECONFIG=/home/ubuntu/.kube/config

helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
helm repo add jetstack https://charts.jetstack.io
helm repo update

kubectl create namespace cattle-system

kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.11.0/cert-manager.crds.yaml

helm repo update

# Install the cert-manager Helm chart
helm install cert-manager jetstack/cert-manager \
    --namespace cert-manager \
    --create-namespace \
    --version v1.11.0

# Wait for cert-manager pods to be ready
kubectl wait --for=condition=Ready --timeout=600s -n cert-manager --all pods

helm install rancher rancher-stable/rancher \
    --namespace cattle-system \
    --set hostname=$1 \
    --set bootstrapPassword=admin

# Wait for rancher pods to be ready
kubectl wait --for=condition=Ready --timeout=600s -n cattle-system --all pods