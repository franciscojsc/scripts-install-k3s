#!/bin/bash

echo "  _    ____       __          __        _             "
echo " | |  |___ \      \ \        / /       | |            "
echo " | | __ __) |___   \ \  /\  / /__  _ __| | _____ _ __ "
echo " | |/ /|__ </ __|   \ \/  \/ / _ \| '__| |/ / _ \ '__|"
echo " |   < ___) \__ \    \  /\  / (_) | |  |   <  __/ |   "
echo " |_|\_\____/|___/     \/  \/ \___/|_|  |_|\_\___|_|   "

sleep 5


echo
echo "Update repository"
echo

sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y autoremove
sudo apt-get -y clean

echo
echo "Install Docker"
echo

curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker pi

echo
echo "Keyboard PT-BR"
echo

sudo sed -i 's/^XKBMODEL.*/XKBMODEL="abnt2"/g' /etc/default/keyboard
sudo sed -i 's/^XKBLAYOUT.*/XKBLAYOUT="br"/g' /etc/default/keyboard
sudo service keyboard-setup restart

echo
echo "Timezone  America/Recife"
echo

sudo timedatectl set-timezone America/Recife

echo
echo "Disable Swap"
echo

sudo swapoff -a
sudo systemctl disable dphys-swapfile.service

echo
echo "Memory GPU -> 16MB"
echo

sudo sh -c "echo 'gpu_mem=16' >> /boot/config.txt"

echo
echo "Enable features of container"
echo

sudo sed -i 's/$/ cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory/' /boot/cmdline.txt

echo
echo "Config network"
echo

sudo sh -c "echo 'net.ipv4.ip_forward=1'  >> /etc/sysctl.conf"
sudo sh -c "echo 'net.bridge.bridge-nf-call-iptables=1'  >> /etc/sysctl.conf"
sudo sysctl -p

echo

OK=N
while [ $OK != "Y" ]; do

      read -p "Enter the master node IP: " IP
      echo
      echo "$IP"
      echo

      read -p "Enter the master node token: " TOKEN
      echo
      echo "$TOKEN"
      echo

      read -p "Are the IP and Token correct? Y/N: " OK

      if [ $OK == "y" ]; then
	      OK="Y"
      fi

      echo
done

echo
echo "Install k3s Worker"
echo

curl -sfL https://get.k3s.io | K3S_URL=https://${IP}:6443 K3S_TOKEN=${TOKEN} INSTALL_K3S_VERSION=v0.9.1   sh -

echo
echo "   ______ _       _     _              _ "
echo "  |  ____(_)     (_)   | |            | |"
echo "  | |__   _ _ __  _ ___| |__   ___  __| |"
echo "  |  __| | | '_ \| / __| '_ \ / _ \/ _\` |"
echo "  | |    | | | | | \__ \ | | |  __/ (_| |"
echo "  |_|    |_|_| |_|_|___/_| |_|\___|\__,_|"