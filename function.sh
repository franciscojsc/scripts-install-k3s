#!/bin/bash

function messageInitMaster {
  echo
  echo "  _    ____        __  __           _            "
  echo " | |  |___ \      |  \/  |         | |           "
  echo " | | __ __) |___  | \  / | __ _ ___| |_ ___ _ __ "
  echo " | |/ /|__ </ __| | |\/| |/ _\` / __| __/ _ \ '__|"
  echo " |   < ___) \__ \ | |  | | (_| \__ \ ||  __/ |   "
  echo " |_|\_\____/|___/ |_|  |_|\__,_|___/\__\___|_|   "
  echo

  sleep $1
}

function messageInitAgent {
  echo
  echo "  _    ____       __          __        _             "
  echo " | |  |___ \      \ \        / /       | |            "
  echo " | | __ __) |___   \ \  /\  / /__  _ __| | _____ _ __ "
  echo " | |/ /|__ </ __|   \ \/  \/ / _ \| '__| |/ / _ \ '__|"
  echo " |   < ___) \__ \    \  /\  / (_) | |  |   <  __/ |   "
  echo " |_|\_\____/|___/     \/  \/ \___/|_|  |_|\_\___|_|   "
  echo

  sleep $1
}

function createLog {
    touch $1
    echo " " >> $1
    echo "*********************************" >> $1
    echo "*********************************" >> $1
    echo "*********************************" >> $1
    echo " " >> $1
    echo "              Log" >> $1
    echo " " >> $1
    date >> $1
    echo " " >> $1
    echo "*********************************" >> $1
    echo "*********************************" >> $1
    echo "*********************************" >> $1
    echo " " >> $1
}

function net {
  ping www.google.com -c 5 >> $1 2>&1
  RESULT=$?
  if [ $RESULT -eq 0 ]
  then
    echo ' [OK] Connection Internet'
  else
    echo ' [  ] Connection Internet'
    exit 1
  fi;
}

function update {
  sudo apt-get update >> $1 2>&1
  RESULT=$?
  if [ $RESULT -eq 0 ]
  then
    echo ' [OK] Update Repository'
  else
    echo ' [  ] Update Repository'
  fi;
}

function docker {
  if sudo curl -fsSL https://get.docker.com | sh >> $1 2>&1 ;
  then
    echo ' [OK] Docker Install'
  else
    echo ' [  ] Docker Install'
  fi;
}

function dockerUser {
  if sudo usermod -aG docker $USER >> $1 ;
  then
    echo ' [OK] Add user to grup Docker'
  else
    echo ' [  ] Add user to grup Docker'
  fi;
}

function keyboard {
  if sudo sed -i 's/^XKBMODEL.*/XKBMODEL="abnt2"/g' /etc/default/keyboard >> $1 && \
  sudo sed -i 's/^XKBLAYOUT.*/XKBLAYOUT="br"/g' /etc/default/keyboard >> $1 && \
  sudo service keyboard-setup restart >> $1 ;
  then
    echo ' [OK] Keyboard PT-BR'
  else
    echo ' [  ] Keyboard PT-BR'
  fi;
}

function timezone {
  if sudo timedatectl set-timezone America/Recife >> $1 2>&1;
  then
    echo ' [OK] Timezone  America/Recife'
  else
    echo ' [  ] Timezone  America/Recife'
  fi;
}

function swap {
  if sudo swapoff -a >> $1 2>&1 && sudo systemctl disable dphys-swapfile.service >> $1 2>&1;
  then
    echo ' [OK] Disable Swap'
  else
    echo ' [  ] Disable Swap'
  fi;
}

function gpuMem {
  if sudo sh -c "echo 'gpu_mem=16' >> /boot/config.txt" >> $1 2>&1;
  then
    echo ' [OK] Memory GPU -> 16MB'
  else
    echo ' [  ] Memory GPU -> 16MB'
  fi;
}

function featuresContainer {
  if sudo sed -i 's/$/ cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory/' /boot/cmdline.txt >> $1 2>&1;
  then
    echo ' [OK] Enable features of container'
  else
    echo ' [  ] Enable features of container'
  fi;
}

function configNet {
  if sudo sh -c "echo 'net.ipv4.ip_forward=1'  >> /etc/sysctl.conf" >> $1 2>&1 && \
  sudo sh -c "echo 'net.bridge.bridge-nf-call-iptables=1'  >> /etc/sysctl.conf" >> $1 2>&1 && \
  sudo sysctl -p >> $1 2>&1 ;
  then
    echo ' [OK] Config network'
  else
    echo ' [  ] Config network'
  fi;
}

function k3sMaster {
  if curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v0.9.1 sh - >> $1 2>&1;
  then
    echo ' [OK] Install k3s'
    echo
    echo 'IP k3s Master'
    ifconfig | grep netmask | grep inet | grep netmask | grep broadcast | cut -d " " -f10
    echo 'Token k3s Master'
    sudo cat  /var/lib/rancher/k3s/server/node-token
  else
    echo ' [  ] Install k3s'
  fi;
}

function k3sAgent {
  OK=N
  while [ $OK != "Y" ]; do
    read -p 'Enter the master node IP: ' IP
    echo
    echo $IP
    echo
    read -p 'Enter the master node token: ' TOKEN
    echo
    echo $TOKEN
    echo
    read -p 'Are the IP and Token correct? Y/N: ' OK

    if [ $OK == 'y' ]; then
      OK='Y'
    fi
    echo
  done

  if curl -sfL https://get.k3s.io | K3S_URL=https://${IP}:6443 K3S_TOKEN=${TOKEN} INSTALL_K3S_VERSION=v0.9.1   sh - >> $1 2>&1;
  then
    echo ' [OK] Install k3s'
  else
    echo ' [  ] Install k3s'
  fi;
}

function messageEnd {
  for i in 1 2 3 4 5 6 7 8 9 10; do
    sleep 1;
    echo -en ". ";
  done

  echo
  echo
  echo "   ______ _       _     _              _ "
  echo "  |  ____(_)     (_)   | |            | |"
  echo "  | |__   _ _ __  _ ___| |__   ___  __| |"
  echo "  |  __| | | '_ \| / __| '_ \ / _ \/ _\` |"
  echo "  | |    | | | | | \__ \ | | |  __/ (_| |"
  echo "  |_|    |_|_| |_|_|___/_| |_|\___|\__,_|"
  echo
  echo
}
