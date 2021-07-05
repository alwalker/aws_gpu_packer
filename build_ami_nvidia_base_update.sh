#stop auto updates
apt-get -y remove unattended-upgrades

#update to latest everything
apt-get -y update
apt-get -y dist-upgrade
apt-get -y autoremove