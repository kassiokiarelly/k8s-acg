#!/bin/bash

cat kernel-modules.conf | tee /etc/modules-load.d/containerd.conf | xargs modprobe
cat kubernetes-cri.conf | tee /etc/sysctl.d/99-kubernetes-cri.conf
sysctl --system
apt-get update && apt-get install -y containerd curl apt-transport-https
mkdir -p /etc/containerd
containerd config default | tee /etc/containerd/config.toml
systemctl restart containerd
swapoff -a

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list

apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl
