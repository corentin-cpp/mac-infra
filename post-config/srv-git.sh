#!/bin/bash

# Sécurisation
systemctl enable fail2ban
systemctl start fail2ban

# Git bare repo exemple
sudo -u git mkdir -p /home/git/repos/demo.git
cd /home/git/repos/demo.git && sudo -u git git init --bare

# Backup des clés SSH
cp /home/git/.ssh/authorized_keys /home/git/.ssh/authorized_keys.bak

echo "[+] srv-git post-config terminée"