#!/bin/bash

sudo apt-get update && sudo apt-get install -y ca-certificates curl gnupg lsb-release apt-transport-https

# containerd.io
curl -fsSL https://get.docker.com | sudo bash

# k8s
sudo curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

cat kernel-modules.conf | sudo tee /etc/modules-load.d/containerd.conf | sudo xargs modprobe
cat kubernetes-cri.conf | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
sudo sysctl --system

sudo systemctl restart containerd
sudo swapoff -a

sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
