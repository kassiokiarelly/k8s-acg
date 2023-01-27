#!/bin/bash

sudo apt-get update && sudo apt-get install -y ca-certificates curl gnupg lsb-release apt-transport-https

# containerd.io
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# k8s
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

cat kernel-modules.conf | sudo tee /etc/modules-load.d/containerd.conf | sudo xargs modprobe
cat kubernetes-cri.conf | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
sudo sysctl --system

sudo apt-get update && sudo apt-get install -y containerd.io 
sudo mkdir -p /etc/containerd
sudo systemctl restart containerd
sudo swapoff -a

sudo apt-get install -y kubelet=1.24.10-00 kubeadm=1.24.10-00 kubectl=1.24.10-00
sudo apt-mark hold kubelet kubeadm kubectl
