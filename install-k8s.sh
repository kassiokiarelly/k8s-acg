#!/bin/bash

sudo apt-get update && sudo apt-get install -y ca-certificates curl gnupg lsb-release apt-transport-https

# containerd.io
curl -fsSL https://get.docker.com | sudo bash

touch containerd.conf
echo "overlay" > tee containerd.conf
echo "br_netfilter" >> tee containerd.conf
sudo mv containerdd.conf /etc/modules-load.d/
cat /etc/modules-load.d/containerd.conf | sudo xargs modprobe

touch 99-kubernetes-cri.conf
echo "net.bridge.bridge-nf-call-iptables  = 1" >  tee 99-kubernetes-cri.conf
echo "net.bridge.bridge-nf-call-ip6tables = 1" >> tee 99-kubernetes-cri.conf
echo "net.ipv4.ip_forward                 = 1" >> tee 99-kubernetes-cri.conf
sudo mv 99-kubernetes-cri.conf /etc/sysctl.d/
sudo sysctl --system

sudo mv /etc/containerd/config.toml /etc/containerd/config.toml.bkp
containerd config default > config.toml
sudo sed -i "s/SystemdCgroup = false/SystemdCgroup = true/" config.toml
sudo mv config.toml /etc/containerd
sudo systemctl restart containerd
sudo swapoff -a

# k8s
sudo curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
